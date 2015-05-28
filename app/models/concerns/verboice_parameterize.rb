module VerboiceParameterize
  def to_verboice_params
    {
      channel_id: Setting[:channel],
      call_flow_id: self.get_call_flow,
      schedule_id: self.get_schedule,
      address: self.phone_number,

      vars: {
        year: self.expiration_date.year,
        month: self.expiration_date.month,
        day: self.expiration_date.day
      }
    }
  end
end