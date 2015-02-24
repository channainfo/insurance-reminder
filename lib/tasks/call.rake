namespace :verboice do
  desc "Call a client"
  task call: :environment do
    clients  = Client.will_expire_on(Date.new(2015,11,9))
    Service::Verboice.connect.call(clients.last)
  end

  desc "Call clients"
  task bulk_call: :environment do
    clients  = Client.will_expire_on(Date.new(2015,11,9))
    response = Service::Verboice.connect.bulk_call(clients)
  end

  desc "Retry to call a client"
  task retry_call: :environment do
    call = Call.last
    Service::Verboice.connect.retry_call(call)
  end

end