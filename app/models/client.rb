class Client < ActiveRecord::Base
  validates :beneficiary_id, uniqueness: true
  has_many :calls, dependent: :destroy

  include VerboiceParameterize, ShpaTransform

  def self.import(spa_beneficiaries)
    if spa_beneficiaries
      ActiveRecord::Base.transaction do
        spa_beneficiaries.each do |spa_beneficiary|
          client = self.create_or_update_for(spa_beneficiary)
          yield(client) if block_given?
        end
      end
    end
  end

  def self.will_expire_on(date)
    where(['expiration_date = ?', date])
  end

  def self.create_or_update_for(spa_beneficiary)
    client_params = Client.shpa_to_client_params(spa_beneficiary)
    client = Client.where(beneficiary_id: client_params[:beneficiary_id]).first_or_initialize
    client.update_attributes(client_params)
    client
  end

  def self.import_expired_shpa_clients_on date
    shpa = Service::Shpa.connect
    spa_beneficiaries = shpa.expired_on(date)

    import(spa_beneficiaries) do |client|
      Verboice.connect.prepare_call_for(client)
    end
    Verboice.connect.release_call
  end

  def self.find_by_phone_number_on_local_or_remote(phone_number)
     Client.find_by_phone_number_on_local(phone_number) || Client.find_by_phone_number_on_remote(phone_number)
  end

  def self.find_by_phone_number_on_local(phone_number)
    Client.find_by(phone_number: phone_number)
  end

  def self.find_by_phone_number_on_remote(phone_number)
    shpa = Service::Shpa.connect
    spa_beneficiaries = shpa.fetch_by(phone_number: phone_number)
    if(!spa_beneficiaries.empty?)
      spa_beneficiary = spa_beneficiaries.first
      self.create_or_update_for(spa_beneficiary)
    else
      nil
    end
  end

end
