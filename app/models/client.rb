class Client < ActiveRecord::Base
  validates :family_code, uniqueness: true
  has_many :calls

  def self.import(imported_clients)
    ActiveRecord::Base.transaction do
      imported_clients.each do |imported_client|
        self.create_or_update_for(imported_client)
      end
    end
  end

  def self.create_or_update_for(imported_client)
    client = Client.where(family_code: imported_client[:family_code]).first_or_initialize
    client.update_attributes(imported_client)
  end

  def self.expire_on date
    all
  end

end
