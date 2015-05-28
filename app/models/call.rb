require 'csv'
class Call < ActiveRecord::Base
  include VerboiceParameterize

  validates :kind, :od_id, presence: true
  has_many :recalls, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client, counter_cache: true
  belongs_to :od, class_name: "OperationalDistrict"

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"
  STATUS_RETRIED = "Retried"
  STATUS_SUCCESS = "Success"
  STATUS_RETRIEVED = "Retrieved"
  STATUS_DISABLED = "Disabled"
  
  STATUSES = [STATUS_PENDING, STATUS_FAILED, STATUS_ERROR, STATUS_SUCCESS,STATUS_RETRIEVED,STATUS_DISABLED]

  TEMPLATE_HEADER = ['Phone number', 'Family code', 'Full name', 'Expiration date', 'OD Code']

  KIND_AUTO = 1
  KIND_MANUAL = 2

  after_save :observe_main_status

  class << self
    def new_from(client)
      call = client.calls.build(
        expiration_date: client.expiration_date,
        phone_number: client.phone_number,
        family_code: client.family_code,
        full_name: client.full_name,
        status: Call::STATUS_RETRIEVED,
        kind: client.kind,
        od_id: client.od_id)
      call.save!

      call
    end

    def search options
      calls = where("1=1")
      calls = calls.where(['phone_number = ?', options[:phone_number]]) if options[:phone_number].present?
      calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
      calls = calls.where(['status in (?)', options[:status]]) if options[:status].present?
      calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
      calls = calls.where(['calls.expiration_date >= ?', options[:expiration_date_start]]) if options[:expiration_date_start].present?
      calls = calls.where(['calls.expiration_date <= ?', options[:expiration_date_end]]) if options[:expiration_date_end].present?
      calls
    end

    def to_csv
      CSV.open(csv_file, 'wb') do |csv|
        csv << ['Family code', 'Full name', 'Call status', 'Recalls', 'Expiration date', 'Phone number', 'Reminder date']
        find_each do |call|
          recalls = call.calls_count > 0 ? call.calls_count : ''
          csv << [ call.family_code, call.full_name, call.status, recalls,
                   call.expiration_date, call.phone_number, call.created_at.to_date]
        end
      end
    end

    def get_template_file
      CSV.open(template_file, 'wb') do |csv|
        csv << TEMPLATE_HEADER
      end
    end

    def csv_file
      "#{Rails.root}/tmp/call.csv"
    end

    def template_file
      "#{Rails.root}/tmp/template.csv"
    end

    def main_calls
      where('main_id is NULL')
    end

    def my_ods ods
      where(" od_id in (?)", ods)
    end

    def mark_delay_as_error_before! datetime
      pendings_call = Call.where(['status = ?', Call::STATUS_PENDING])
      pendings_call.each do |call|
        if call.updated_at <= datetime
          call.status = Call::STATUS_ERROR
          call.save!
        end
      end
    end

    def call_records_expired
      from_date = Date.today
      
      queued_calls = []
      Call.where("status = ?", Call::STATUS_RETRIEVED).each do |c|
        od = OperationalDistrict.where("external_id = ?", c.od_id)
        to = from_date + (od[0].od_setting.day_expired_call.to_i - 1).days
        if to > c.expiration_date
          queued_calls << c
        end
      end
      Service::Verboice.connect().bulk_enqueue!(queued_calls) unless queued_calls.empty?
    end
  end

  def get_call_flow
    od = OperationalDistrict.where("id = ?", self.od_id)
    org = Organization.all.select { |m| m.ods.include? od.first.id.to_s}
    unless org.empty?
      callflow_id = org.first.organization_setting ? org.first.organization_setting.callflow_id : Setting[:call_flow]
    else
      callflow_id = Setting[:call_flow]
    end
    return callflow_id
  end

  def get_schedule
    od = OperationalDistrict.where("id = ?", self.od_id)
    org = Organization.all.select { |m| m.ods.include? od.first.id.to_s}
    unless org.empty?
      callflow_id = org.first.organization_setting ? org.first.organization_setting.schedule_id : Setting[:schedule]
    else
      callflow_id = Setting[:schedule]
    end
    return callflow_id
  end

  def observe_main_status
    return if main.nil?

    if main.error? && main.reaches_max_recalls?
      main.status = Call::STATUS_FAILED
      main.save!
    end
  end

  def retryable?
    main? && !pending?
  end

  def main?
    self.main.nil?
  end

  def error?
    status == Call::STATUS_ERROR
  end

  def failed?
    status == Call::STATUS_FAILED
  end

  def pending?
    status == Call::STATUS_PENDING
  end

  def reaches_max_recalls?
    (calls_count + 1) >= Setting[:recalls].to_i # late 1 when sub call was retried in counter_cached
  end

  def mark_as_error!
    self.status = Call::STATUS_ERROR
    save!
    if main
      main.status = Call::STATUS_ERROR
      main.save!
    end
  end

  def mark_as_success!
    self.status = Call::STATUS_SUCCESS
    save!
    if main
      main.status = Call::STATUS_SUCCESS
      main.save!
    end
  end

  def kind_text
    kind == Call::KIND_AUTO ? 'Auto' : 'Manual'
  end

  def self.validate_data(key, value)
    error = false
    message = ""
    if value.nil? or value.empty?
      error = true
      message = "Can't be blank"
    else
      case key
      when 'OD Code'
        error = true unless OperationalDistrict.find_by_code value
        message = "Unknown OD" if error
      when 'Expiration date'
        begin
          Date.parse(value)
        rescue ArgumentError
          error = true
          message = "Incorrect format(YY-mm-dd)"
        end
      end
    end
    [error, message]
  end
end
