class Call < ActiveRecord::Base
  has_many :retries, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client, counter_cache: true

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"
  STATUS_RETRIED = "Retried"
  STATUSES = [STATUS_PENDING, STATUS_FAILED, STATUS_ERROR]


  def self.search options
    calls = where("1=1")
    calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
    calls = calls.where(['status = ?', options[:status]]) if options[:status].present?
    calls = calls.where(['family_code = ?', options[:family_code]]) if options[:family_code].present?
    calls = calls.where(['calls.expiration_date >= ?', options[:expiration_date_start]]) if options[:expiration_date_start].present?
    calls = calls.where(['calls.expiration_date <= ?', options[:expiration_date_end]]) if options[:expiration_date_end].present?
    calls
  end

  def self.main_calls
    where('main_id is NULL')
  end

  def retryable?
    main? && error?
  end

  def main?
    self.main.nil?
  end

  def error?
    status == Call::STATUS_ERROR
  end
end
