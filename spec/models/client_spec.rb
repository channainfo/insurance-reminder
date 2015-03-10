require 'rails_helper'

RSpec.describe Client, :type => :model do
  it { should validate_presence_of(:phone_number) }
  it { should validate_presence_of(:kind) }
  it { should validate_uniqueness_of(:beneficiary_id) }

  describe '.will_expire_on' do
    it 'return clients that expired date match the date' do
      expiration_date = Date.new(2050,11 , 9)
      create(:client, expiration_date: expiration_date)
      create(:client, expiration_date: expiration_date)
      create(:client, expiration_date: expiration_date)
      expect(Client.will_expire_on(expiration_date).count).to eq 3
    end
  end

  describe '.create_or_update_for client from webservices' do
    let!(:client) { create(:client, beneficiary_id: 1, family_code: '0123-123456-12345', phone_number: '0120009000')}
    context 'new client' do
      it 'create client to database' do
        imported_client = {'phone_number' => '0975552345', 'full_name' => 'foo', 'contract' => {'expiration_date' => '2012-10-10'}, 'family' => {'family_code' => '4433-123456-22233', }}
        expect{Client.create_or_update_for(imported_client)}.to change{Client.count}.by(1)
        client = Client.last
        expect_client_to_be(client, {full_name: 'foo', family_code: '4433-123456-22233', phone_number: '0975552345', expiration_date: Date.new(2012,10,10)})
      end
    end

    context 'for existing client' do
      it 'update the client' do
        imported_client = {'id' => 1, 'phone_number' => '0975553553', 'full_name' => 'foo', 'contract' => {'expiration_date' => '2013-12-12'}, 'family' => {'family_code' => '0123-123456-12345'}}
        expect{Client.create_or_update_for(imported_client)}.to change{Client.count}.by(0)
        client = Client.last
        expect_client_to_be(client, {full_name: 'foo', family_code: '0123-123456-12345', phone_number: '0975553553', expiration_date: Date.new(2013,12,12)})
      end
    end
  end

  describe '.import clients from web service' do
    it 'create or update the client on local database' do
      imported_clients = [
        { 'id' => 1, 'phone_number' => '097552222', 'full_name' => 'foo', 'family' => {'family_code' => '4433-123456-22222'}, 'contract' => {'expiration_date' => '2010-10-10'} },
        { 'id' => 2, 'phone_number' => '097553333', 'full_name' => 'foo', 'family' => {'family_code' => '4433-123456-33333'}, 'contract' => {'expiration_date' => '2012-11-11'} }
      ]

      Client.import(imported_clients)
      clients = Client.last(2)
      expect_client_to_be(clients.first, {full_name: 'foo', family_code: '4433-123456-22222', phone_number: '097552222', expiration_date: Date.new(2010,10,10)} )
      expect_client_to_be(clients.last, {full_name: 'foo', family_code: '4433-123456-33333', phone_number: '097553333', expiration_date: Date.new(2012,11,11)} )
    end
  end

  def expect_client_to_be(client, client_hash)
    expect(client.full_name).to eq client_hash[:full_name]
    expect(client.family_code).to eq client_hash[:family_code]
    expect(client.phone_number).to eq client_hash[:phone_number]
    expect(client.expiration_date).to eq client_hash[:expiration_date]
  end
end
