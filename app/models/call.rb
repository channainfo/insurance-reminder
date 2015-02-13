class Call < ActiveRecord::Base
  has_many :retries, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client, counter_cache: true

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"
  STATUS_RETRIED = "Retried"
  STATUSES = [STATUS_PENDING, STATUS_FAILED, STATUS_ERROR]


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
