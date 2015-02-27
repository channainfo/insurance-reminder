require 'csv'
class Call < ActiveRecord::Base
  has_many :retries, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client, counter_cache: true

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"
  STATUS_RETRIED = "Retried"
  STATUS_SUCCESS = "Success"
  STATUSES = [STATUS_PENDING, STATUS_FAILED, STATUS_ERROR, STATUS_SUCCESS]

  MAX_RETRY_NUMBER = 5

  before_save :observe_status

  def observe_status
    if self.status == Call::STATUS_ERROR && self.calls_count > MAX_RETRY_NUMBER
      self.status = Call::STATUS_FAILED
    end
  end

  def self.search options
    calls = where("1=1")
    calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
    calls = calls.where(['status = ?', options[:status]]) if options[:status].present?
    calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
    calls = calls.where(['calls.expiration_date >= ?', options[:expiration_date_start]]) if options[:expiration_date_start].present?
    calls = calls.where(['calls.expiration_date <= ?', options[:expiration_date_end]]) if options[:expiration_date_end].present?
    calls
  end

  def self.to_csv
    CSV.open(csv_file, 'wb') do |csv|
      csv << ['Family code', 'Full name', 'Call status', 'Retries', 'Expiration date', 'Phone number', 'Reminder date']
      find_each do |call|
        csv << [ call.client.family_code, call.client.full_name, call.status, call.calls_count,
                 call.expiration_date, call.phone_number, call.created_at.to_date]
      end
    end
  end

  def self.csv_file
    "#{Rails.root}/tmp/call.csv"
  end

  def self.main_calls
    where('main_id is NULL')
  end

  def retryable?
    main? && error? && calls_count < MAX_RETRY_NUMBER
  end

  def main?
    self.main.nil?
  end

  def error?
    status == Call::STATUS_ERROR
  end

  def mark_as_error!
    self.status = Call::STATUS_ERROR
    save!
    if self.main
      main.status = Call::STATUS_ERROR
      main.save!
    end
  end

  def mark_as_success!
    self.status = Call::STATUS_SUCCESS
    save!
    if self.main
      main.status = Call::STATUS_SUCCESS
      main.save!
    end
  end

end
