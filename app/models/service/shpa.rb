module Service
  class Shpa
    def self.connect
      @@instance ||= Shpa.new
    end

    def initialize
      @username = ENV['SHPA_USERNAME']
      @password = ENV['SHPA_PASSWORD']
    end

    def fetch_by(params = {})
      url = build_url("beneficiaries")
      response = Typhoeus.get(url, params: params, userpwd: "#{@username}:#{@password}")
      response.success? ? JSON.parse(response.response_body) : nil
    end

    def build_url(path)
      ENV['SHPA_API_URL'] + "/" + path
    end

    def expired_on date
      fetch_by(expiration_date: date)
    end
  end
end
