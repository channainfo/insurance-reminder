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
      response = Typhoeus.get(url, headers: {'Content-Type'=> "application/json"}, body: to_json(params), userpwd: "#{@username}:#{@password}")
      response.success? ? JSON.parse(response.response_body) : nil
    end

    def expired_between_in_od from_date, to_date, od_ids
      fetch_by(from_date: from_date, to_date: to_date, od_ids: od_ids)
    end

    private

    def build_url(path)
      ENV['SHPA_API_URL'] + "/" + path
    end

    def to_json params
      JSON.generate(params)
    end

  end
end
