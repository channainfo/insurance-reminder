class Client < ActiveRecord::Base
  validates :beneficiary_id, uniqueness: true
  has_many :calls, dependent: :destroy

  include ShpaTransform

  def self.import(shpa_beneficiaries)
    if shpa_beneficiaries
      ActiveRecord::Base.transaction do
        shpa_beneficiaries.each do |shpa_beneficiary|
          client = self.create_or_update_for(shpa_beneficiary)
          yield(client) if block_given?
        end
      end
    end
  end

  def self.will_expire_on(date)
    where(['expiration_date = ?', date])
  end

  def self.create_or_update_for(beneficiary)
    client_params = Client.shpa_to_client_params(beneficiary)
    client = Client.where(beneficiary_id: client_params[:beneficiary_id]).first_or_initialize
    client.update_attributes(client_params)
    client
  end

  def self.get_shpa_beneficiaries_expired_between from_date, to_date
    shpa = Service::Shpa.connect
    shpa.expired_between(from_date, to_date)
  end

  def self.import_shpa_beneficiaries_expired_between from_date, to_date
    queued_calls = []

    shpa_beneficiaries = get_shpa_beneficiaries_expired_between(from_date, to_date)

    import(shpa_beneficiaries) do |client|
      next if client.phone_number.blank? or client.expiration_date.nil?

      if Expiration.register client
        call = Call.new_from(client)
        queued_calls << call
      end
    end

    Service::Verboice.bulk_call(queued_calls) unless queued_calls.empty?
  end

  def self.find_by_phone_number_on_local_or_remote(phone_number)
     Client.find_by_phone_number_on_local(phone_number) || Client.find_by_phone_number_on_remote(phone_number)
  end

  def self.find_by_phone_number_on_local(phone_number)
    Client.find_by(phone_number: phone_number)
  end

  def self.find_by_phone_number_on_remote(phone_number)
    shpa = Service::Shpa.connect
    shpa_beneficiaries = shpa.fetch_by(phone_number: phone_number)
    if(!shpa_beneficiaries.empty?)
      shpa_beneficiary = shpa_beneficiaries.first
      self.create_or_update_for(shpa_beneficiary)
    else
      nil
    end
  end

end
