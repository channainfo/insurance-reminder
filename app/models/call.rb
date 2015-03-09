require 'csv'
class Call < ActiveRecord::Base
  include VerboiceParameterize

  has_many :retries, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client, counter_cache: true

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"
  STATUS_RETRIED = "Retried"
  STATUS_SUCCESS = "Success"
  STATUSES = [STATUS_PENDING, STATUS_FAILED, STATUS_ERROR, STATUS_SUCCESS]

  after_save :observe_main_status

  class << self
    def new_from(client)
      call = client.calls.build(
        expiration_date: client.expiration_date,
        phone_number: client.phone_number,
        family_code: client.family_code,
        status: Call::STATUS_ERROR)
      call.save!

      call
    end

    def search options
      calls = where("1=1")
      calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
      calls = calls.where(['status = ?', options[:status]]) if options[:status].present?
      calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
      calls = calls.where(['calls.expiration_date >= ?', options[:expiration_date_start]]) if options[:expiration_date_start].present?
      calls = calls.where(['calls.expiration_date <= ?', options[:expiration_date_end]]) if options[:expiration_date_end].present?
      calls
    end

    def to_csv
      CSV.open(csv_file, 'wb') do |csv|
        csv << ['Family code', 'Full name', 'Call status', 'Retries', 'Expiration date', 'Phone number', 'Reminder date']
        find_each do |call|
          csv << [ call.client.family_code, call.client.full_name, call.status, call.calls_count,
                   call.expiration_date, call.phone_number, call.created_at.to_date]
        end
      end
    end

    def csv_file
      "#{Rails.root}/tmp/call.csv"
    end

    def main_calls
      where('main_id is NULL')
    end

    def mark_delay_as_error_before! datetime
      main_calls.each do |call|
        if call.pending? && call.past_of?(datetime)
          call.status = Call::STATUS_ERROR
          call.save!
        end
      end
    end
  end

  def observe_main_status
    return if main.nil?

    if main.error? && main.reaches_max_retries?
      main.status = Call::STATUS_FAILED
      main.save!
    end
  end

  def retryable?
    main? && (error? or failed?)
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

  def reaches_max_retries?
    (calls_count + 1) >= Setting[:retries].to_i # late 1 when sub call was retried in counter_cached
  end

  def past_of?(datetime)
    updated_at <= datetime
  end

  def mark_as_error!
    status = Call::STATUS_ERROR
    save!
    if main
      main.status = Call::STATUS_ERROR
      main.save!
    end
  end

  def mark_as_success!
    status = Call::STATUS_SUCCESS
    save!
    if main
      main.status = Call::STATUS_SUCCESS
      main.save!
    end
  end

end
