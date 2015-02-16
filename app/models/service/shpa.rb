module Service
  class Shpa < Authentication::Basic
    BENEFICIARIES_PATH = 'beneficiaries'

    def initialize(username, password)
      super(username, password)
    end

    def expired_within number_of_day
      get BENEFICIARIES_PATH, day: number_of_day
    end

    def build_url(path)
      File.join(ENV['SHPA_API_URL'], path)
    end
  end
end
