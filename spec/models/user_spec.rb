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

end
