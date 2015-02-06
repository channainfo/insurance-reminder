namespace :verboice do
  desc "Call a number"
  task call: :environment do
    clients  = Client.expire_on(Date.current)
    response = Verboice.connect.call(clients)
  end

  desc "Retry to call a client"
  task retry_call: :environment do
    Verboice.connect.retry_call(Client.last)
  end
end