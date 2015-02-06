require 'net/http'

class Verboice
  attr_accessor :token

  def initialize(email, password)
    @email = email
    @password = password
  end

  def authenticate
    auth_url = build_url("/auth")
    response = Typhoeus.post(auth_url, body: { account: { email: @email, password: @password } })
    self.token = JSON.parse(response.body)['auth_token']

    response.success?
  end

  # def token
  #   # pending defintion
  # end

  def enqueue_call(phone_number, channel)
    post("/call", { address: phone_number, channel: channel })
  end

  private

  def get(path)
    respone = Typhoeus.get(build_url(path))
    JSON.parse(response.response_body)
  end

  def post(path, params)
    with_auth_params = params.merge({ email: @email, auth_token: token })
    p with_auth_params
    response = Typhoeus.post(build_url(path), body: with_auth_params)
    JSON.parse(response.response_body)
  end

  def build_url(path)
    ENV['VERBOICE_URL'] + path
  end

end
