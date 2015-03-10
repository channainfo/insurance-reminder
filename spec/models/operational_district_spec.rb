require 'rails_helper'

RSpec.describe OperationalDistrict, :type => :model do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:external_id) }
  it { should validate_uniqueness_of(:code) }
  it { should validate_uniqueness_of(:external_id) }

end
