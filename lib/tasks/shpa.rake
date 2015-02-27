namespace :shpa do
  desc "Get all client who those are expired"
  task import_expired_clients: :environment do
    expiration_date = Date.today + Setting[:day_before_expiration_date].to_i.days
    Client.import_expired_shpa_clients_on expiration_date
  end

  task update_delay_call_as_error: :environment do
    Call.mark_delay_as_error!
  end
end
