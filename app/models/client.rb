class Client < ActiveRecord::Base
  validates :family_code, uniqueness: true
  has_many :calls

  include VerboiceParameterize

  def self.import(imported_clients)
    ActiveRecord::Base.transaction do
      imported_clients.each do |imported_client|
        self.create_or_update_for(imported_client)
      end
    end
  end

  def self.will_expire_on(date)
    where(['expiration_date = ?', date])
  end

  def self.create_or_update_for(imported_client)
    client = Client.where(family_code: imported_client[:family_code]).first_or_initialize
    client.update_attributes(imported_client)
  end

  def make_call call_log_id
    call = self.calls.build( expired_date: self.expired_date,
                             phone_number: self.phone_number,
                             call_log_id: call_log_id,
                             status: Call::STATUS_PENDING
                          )
    call.save
  end

  def retry_a_call(call)
    response = Verboice.connect.call(self)
    retry_call = self.calls.build( expired_date: call.expired_date,
                                   phone_number: call.phone_number,
                                   main: call,
                                   call_log_id: response[:call_log_id],
                                   status: Call::STATUS_PENDING)
    retry_call.save
  end

  def call_a_client
    response = Verboice.connect.call(self)
    call = self.calls.build( expired_date: self.expired_date,
                             phone_number: self.phone_number,
                             call_log_id: response[:call_log_id],
                             status: Call::STATUS_PENDING)
    call.save
  end

end
