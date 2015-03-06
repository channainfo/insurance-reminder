class Expiration < ActiveRecord::Base
  validates :date, presence: true
  validates :date, uniqueness: true

  serialize :clients, Array

  def self.register client
    expiration = Expiration.find_or_create_by(date: client.expiration_date)

    expiration.register client
  end

  def register client
    add client unless exist?(client)
  end

  def add client
    clients.push client.id
    save
  end

  def exist? client
    clients.include?(client.id)
  end

end
