require 'rails_helper'

RSpec.describe Expiration, :type => :model do
  it { should validate_presence_of(:date) }
  it { should validate_uniqueness_of(:date) }
end
