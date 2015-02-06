class Verboice

  def self.connect
    @@instance ||= Verboice.new(ENV['EMAIL'], ENV['PASSWORD'])
  end

  def initialize(email, password)
    @email = email
    @password = password
    connect
  end

  def retry_call(client)
    call_a_client(client)
    
    client.number_retry +=1
    client.save!
  end

  def call(clients)
    clients.each do |client|
      call_a_client(client, options)
    end
  end

  def call_a_client(client)
    options = {
      channel_id: ENV['CHANNEL_ID'],
      call_flow_id: ENV['CALL_FLOW_ID'],
      address: client.phone_number,
      vars: {
        year: client.expiration_date.year,
        month: client.expiration_date.month,
        day: client.expiration_date.day,
        family_code: client.family_code
      }
    }
    post("/call", options )
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
    Typhoeus.post(build_url(path), body: auth_params(params))
  end

  def build_url(path)
    ENV['VERBOICE_URL'] + path
  end

  def auth_params(params)
    params.merge({ email: @email, token: @token })
  end

end