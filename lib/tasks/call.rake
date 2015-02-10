namespace :verboice do
  desc "Call a client"
  task call: :environment do
    clients  = Client.expire_on(Date.current)
    response = Verboice.connect.call(clients.last)
  end

  desc "Call clients"
  task bulk_call: :environment do
    clients  = Client.expire_on(Date.current)
    response = Verboice.connect.bulk_call(clients)
  end

  desc "Retry to call a client"
  task retry_call: :environment do
    Verboice.connect.retry_call(Client.last)
  end
end