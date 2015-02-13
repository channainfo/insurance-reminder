module VerboiceParameterize
  def to_verboice_params
    {
      channel_id: ENV['CHANNEL_ID'],
      call_flow_id: ENV['CALL_FLOW_ID'],
      address: self.phone_number,
      vars: {
        year: self.expiration_date.year,
        month: self.expiration_date.month,
        day: self.expiration_date.day,
        family_code: self.family_code
      }
    }
  end
end