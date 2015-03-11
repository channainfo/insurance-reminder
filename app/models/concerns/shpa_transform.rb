module ShpaTransform
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def shpa_to_client_params(shpa_beneficiary)
      phone_number = shpa_beneficiary['phone_number'].gsub(/\s*\-*/, '')
      {
        beneficiary_id: shpa_beneficiary['id'],
        phone_number: phone_number,
        full_name: shpa_beneficiary['full_name'],
        expiration_date: shpa_beneficiary['contract']['expiration_date'],
        family_code: shpa_beneficiary['family']['family_code'],
        od_id: shpa_beneficiary['od_id']
      }
    end
  end
end
