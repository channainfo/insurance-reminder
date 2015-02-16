namespace :shpa do
  desc "Get all client who those are expired"
  task import_expired_clients: :environment do
    Client.import_expired_shpa_clients_within 10
  end
end
