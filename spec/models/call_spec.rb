require 'rails_helper'

RSpec.describe Call, :type => :model do

  it { should validate_presence_of(:kind) }
  
end
