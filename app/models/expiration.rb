class Expiration < ActiveRecord::Base
  validates :date, presence: true
  validates :date, uniqueness: true

  serialize :numbers, Array

  def self.register client
    return if client.phone_number.blank?
    return if client.expiration_date.nil?

    expiration = Expiration.find_or_create_by(date: client.expiration_date)

    expiration.add client.phone_number unless expiration.exist?(client.phone_number)
  end

  def add number
    numbers.push number
    save
  end

  def exist? number
    numbers.include?(number)
  end

end
