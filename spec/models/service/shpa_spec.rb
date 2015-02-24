require 'rails_helper'

RSpec.describe Service::Shpa, :type => :model do
  describe '.get' do
    before(:each) do
      @shpa = Service::Shpa.new 'test', 'test'
    end

    it 'should make a request to SHPA api' do
      stub = stub_request(:get, "#{ENV['SHPA_API_URL']}/beneficiaries").to_return(status: 200, body: '{}')
      @shpa.get('beneficiaries')
      expect(stub).to have_been_requested
    end
  end
end
