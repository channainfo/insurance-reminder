class Call < ActiveRecord::Base
  has_many :retries, class_name: "Call", foreign_key: 'main_id'
  belongs_to :main, class_name: "Call", counter_cache: true
  belongs_to :client

  STATUS_PENDING = "Pending"
  STATUS_FAILED  = "Failed"
  STATUS_ERROR   = "Error"

  def self.main_calls
    where('main_id is NULL')
  end
end
