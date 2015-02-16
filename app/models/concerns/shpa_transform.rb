module ShpaTransform
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def to_client_params(hash = {})
      {
        phone_number: hash['tel'] ? hash['tel'] : nil,
        family_code: hash['family']['code'] ? hash['family']['code'] : nil,
        expiration_date: hash['contracts'].last.nil? ? nil : hash['contracts'].last['expiry_date']
      }
    end
  end
end
