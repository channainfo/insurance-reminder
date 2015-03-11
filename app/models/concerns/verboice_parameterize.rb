module VerboiceParameterize
  def to_verboice_params
    {
      channel_id: Setting[:channel],
      call_flow_id: Setting[:call_flow],
      schedule_id: Setting[:schedule],
      address: self.phone_number,

      vars: {
        year: self.expiration_date.year,
        month: self.expiration_date.month,
        day: self.expiration_date.day
      }
    }
  end
end