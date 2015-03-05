namespace :shpa do
  desc "Get all client who those are expired"
  task import_expired_clients: :environment do
    from_date = Date.today
    to_date = from_date + (Setting[:day_before_expiration_date].to_i - 1).days
    Client.import_shpa_beneficiaries_expired_between from_date, to_date
  end

  task update_delay_call_as_error: :environment do
    Call.mark_delay_as_error!
  end
end
