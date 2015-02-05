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

  private

  def build_url(path)
    ENV['VERBOICE_URL'] + path
  end

end
