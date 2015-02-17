require 'csv'
class Call < ActiveRecord::Base
  has_many :retries, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client, counter_cache: true

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"
  STATUS_RETRIED = "Retried"
  STATUSES = [STATUS_PENDING, STATUS_FAILED, STATUS_ERROR]

  MAX_RETRY_NUMBER = 3

  before_save :monitor_status

  def monitor_status
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
      csv << ['Family code', 'Family name', 'Call status', 'Retries', 'Expiration date', 'Phone number', 'Reminder date']
      find_each do |call|
        csv << [ call.client.family_code, call.client.family_name, call.status, call.calls_count,
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
end
