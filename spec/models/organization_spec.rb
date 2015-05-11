require 'rails_helper'

RSpec.describe Organization, :type => :model do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:ods) }
  it { should validate_uniqueness_of(:name) }

  describe "uniqueness_ods" do
    let(:od_1) { create(:operational_district, name: 'od_1', code: 'od_1', external_id: '1') }
    let(:od_2) { create(:operational_district, name: 'od_2', code: 'od_2', external_id: '2') }

    before(:each) do
      create(:organization, name: 'org_1', ods: ["#{od_1.id}"])
      create(:organization, name: 'org_2', ods: ["#{od_2.id}"])
    end

    it "ignore existing ods those belongs to another organization" do
      new_organization = Organization.new name: 'org_3', ods: ["#{od_1.id}"]
      
      expect(new_organization.valid?).to eq(false)
      expect(new_organization.errors.first).to eq([:ods, "od_1 was owned by org_1"])
    end
  end

end
