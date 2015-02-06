require 'net/http'

class Verboice

  def initialize(email, password)
    @email = email
    @password = password
    connect
  end

  def enqueue_call(address, channel)
    post("/call", { address: address, channel: channel })
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
