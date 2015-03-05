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

    def expired_between from_date, to_date
      fetch_by(from_date: from_date, to_date: to_date)
    end
  end
end
