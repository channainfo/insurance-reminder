require 'rails_helper'

RSpec.describe Client, :type => :model do
  describe '#authenticate to verboice web service ' do
    it 'return true with valid credential' do
      verboice = Verboice.new('vtiffenberg@manas.com.ar','12345678')
      p verboice.authenticate
      p verboice.token
    end
  end
end
