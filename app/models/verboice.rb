class Verboice

  def self.connect
    @@instance ||= Verboice.new(ENV['EMAIL'], ENV['PASSWORD'])
  end

  def initialize(email, password)
    @email = email
    @password = password
    connect
  end

  def bulk_call(clients)
    options = clients.map{|client| client.to_verboice_params}
    response = post("/bulk_call", {call: options})
    call_response = JSON.parse(response.body)
    call_response.each_with_index do |call_attrs, index|
      client = clients[index]
      call = client.calls.build( expiration_date: client.expiration_date,
                                 phone_number: client.phone_number,
                                 verboice_call_id: call_attrs[:call_id],
                                 status: Call::STATUS_PENDING)
      call.save!
    end
  end

  def retry_call(call)
    client = call.client
    options = client.to_verboice_params
    options[:address] = call.phone_number
    response = post("/call", {call: options})
    verboice_call = JSON.parse(response.body)

    call = client.calls.build( expiration_date: call.expiration_date,
                               phone_number: call.phone_number,
                               verboice_call_id: verboice_call[:call_id],
                               status: Call::STATUS_PENDING,
                               main: call)
    call.save
    call.status == Call::STATUS_RETRIED
    call.save!
  end

  def call client
    options = client.to_verboice_params
    response = post("/call", {call: options})
    verboice_call = JSON.parse(response.body)

    call = client.calls.build( expiration_date: client.expiration_date,
                               phone_number: client.phone_number,
                               verboice_call_id: verboice_call[:call_id],
                               status: Call::STATUS_PENDING)
    call.save
  end

  def call_logs params = {}
    verboice_query = auth_params(params.slice(:start_date, :end_date, :channel_id, :status)).to_query
    get("/call_logs?#{verboice_query}")
  end

  private

  def connect
    auth_url = build_url("/auth")
    response = Typhoeus.post(auth_url, body: { account: { email: @email, password: @password } })
    @token = JSON.parse(response.body)['auth_token']
  end

  def get(path)
    response = Typhoeus.get(build_url(path))
    JSON.parse(response.response_body)
  end

  def post(path, params)
    Typhoeus.post(build_url(path), body: JSON.generate(auth_params(params)), headers: {'content-type' => 'application/json'} )
  end

  def build_url(path)
    ENV['VERBOICE_URL'] + path
  end

  def auth_params(params)
    params.merge({ email: @email, token: @token })
  end
end