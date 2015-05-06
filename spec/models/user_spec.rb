require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:username) }
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
    before(:each) do
      @od = create(:operational_district, :name => "OD", :external_id => 100022, :code => '122343')
      @org = create(:organization, :name => "Org", :ods => [@od.id])
      @user = create(:user, username: 'admin', password: '123456', name: 'Admin', role: User::ROLE_ADMIN)
    end
    
    it 'should have user admin' do
      expect(@user.username).to eq("admin")
      expect(@user.ods).to eq([])
      expect(@user.organizations).to eq([])
    end

    it 'should have one od' do
      expect(@user.get_ods.size).to eq(1)
    end

    it 'should have one Organization' do
      expect(Organization.all.size).to eq(1)
      expect(Organization.first.name).to eq('Org')
      expect(@user.get_organization_ids).to eq([@org.id])
    end
  end

  context "reset password" do
    let(:user) { create(:user, username: 'user@example.com', password: 'secret123') }

    it "set a new password" do
      user.reset_password_to("123456")
      expect(user.password).to eq('123456')
    end
  end

  context "change password" do
    let(:user) { create(:user, username: 'user@example.com', password: 'secret123') }

    it "update to a new password" do
      user.change_password('secret123', '123456', '123456')
      expect(user.password).to eq('123456')
    end
  end

end
