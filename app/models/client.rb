class Client < ActiveRecord::Base
  validates :phone_number, presence: true
  validates :kind, presence: true
  validates :beneficiary_id, uniqueness: true, if: :beneficiary_id
  has_many :calls, dependent: :destroy

  include ShpaTransform

  KIND_AUTO = 1
  KIND_MANUAL = 2

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

  def self.get_shpa_beneficiaries_expired_between_in_od from_date, to_date, od_ids
    Service::Shpa.connect.expired_between_in_od from_date, to_date, od_ids
  end

  def self.import_shpa_beneficiaries_expired_between_in_od from_date, to_date, od_ids
    queued_calls = []

    shpa_beneficiaries = get_shpa_beneficiaries_expired_between_in_od(from_date, to_date, od_ids)

    import(shpa_beneficiaries) do |client|
      next if client.phone_number.blank? or client.expiration_date.nil?

      if Expiration.register client
        call = Call.new_from(client)
        queued_calls << call
      end
    end

    Service::Verboice.bulk_enqueue!(queued_calls) unless queued_calls.empty?
  end

  def kind_text
    kind == KIND_AUTO ? 'Auto' : 'Manual'
  end

end
