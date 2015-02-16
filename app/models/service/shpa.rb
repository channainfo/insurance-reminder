module Service
  class Shpa < Authentication::Basic
    def initialize(username, password)
      super(username, password)
    end

    def build_url(path)
      File.join(ENV['SHPA_API_URL'], path)
    end
  end
end
