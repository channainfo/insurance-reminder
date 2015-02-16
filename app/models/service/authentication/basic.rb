module Service
  module Authentication
    class Basic
      def initialize(username, password)
        @username = username
        @password = password
      end

      def get(path, params = {})
        response = Typhoeus.get(build_url(path), params: params, userpwd: "#{@username}:#{@password}")
        JSON.parse(response.response_body)
      end
    end
  end
end
