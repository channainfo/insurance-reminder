require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do
    it {should validate_uniqueness_of(:username)}
    it { should validate_presence_of(:password).on(:create) }
    it { should have_secure_password }

  end

  describe User, '.authenticate' do
    it "authenticates username and password" do
      user = create(:user, username: 'User@example.com', password: 'secret123')
      result = User.authenticate('user@example.com', 'secret123')
      expect(result).to eq(user)
    end

    it 'return false if there is no matchs' do
      create(:user, username: 'user@example.com', password: 'no-matched')
      result = User.authenticate('no_user@example.com', 'secret123')
      expect(result).to eq(false)
    end
  end

  describe User, "get data as admin" do
    od = OperationalDistrict.create(:name => "OD", :external_id =>100022, :code => '122343')
    org = Organization.create(:name => "Org111", :ods => [od.id])
    user = User.create(username: 'admin', password: '123456', name: 'Admin', role: User::ROLE_ADMIN)
    it 'should have user admin' do
      expect(user.username).to eq("admin")
      expect(user.ods).to eq([])
      expect(user.organizations).to eq([])
    end

    it 'should have one od' do
      expect(user.get_ods.size).to eq(1)
    end

    it 'should have one Organization' do
      expect(Organization.all.size).to eq(1)
      expect(Organization.first.name).to eq('Org')
      expect(org.id).to eq(2)
      expect(user.get_organization_ids).to eq([org.id])
    end
  end

end
