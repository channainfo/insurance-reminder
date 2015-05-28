require 'rails_helper'

RSpec.describe Call, :type => :model do

  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:od_id) }

  describe '.validate import data' do
    it 'should validate date if wrong format ' do
    	status = Call.validate_data("Expiration date", "2015-23-12")
    	expect(status[0]).to eq(true)
    	expect(status[1]).to eq("Date format is incorrect.")
    end

    it 'should validate date if correct format ' do
    	status = Call.validate_data("Expiration date", "2015-04-20")
    	expect(status[0]).to eq(false)
    	expect(status[1]).to eq("")
    end

    it 'should validate OD code failed if not existed OD ' do
    	OperationalDistrict.destroy_all
    	status = Call.validate_data("OD Code", "102")
    	expect(status[0]).to eq(true)
    	expect(status[1]).to eq("OD Code is unknown")
    end

    it 'should validate OD code success if OD is existed' do
    	OperationalDistrict.destroy_all
    	od = OperationalDistrict.find_or_create_by({:name => "Hello", :code => "99999", :external_id => 99999, :enable_reminder => false})
    	expect(OperationalDistrict.all.size).to eq(1)
    	status = Call.validate_data("OD Code", "99999")
    	expect(status[0]).to eq(false)
    	expect(status[1]).to eq("")
    end

    it 'should validate date if empty is input' do
    	status = Call.validate_data('Phone number', "012345678899")
    	expect(status[0]).to eq(false)
    	expect(status[1]).to eq("")

			status = Call.validate_data('Family code', "987-2345")
    	expect(status[0]).to eq(false)
    	expect(status[1]).to eq("")

    	status = Call.validate_data('Full name', "UserFullName")
    	expect(status[0]).to eq(false)
    	expect(status[1]).to eq("")    	
    end

    it 'should validate date if empty is input' do
    	status = Call.validate_data('Phone number', "")
    	expect(status[0]).to eq(true)
    	expect(status[1]).to eq("Can't be blank")

			status = Call.validate_data('Family code', "")
    	expect(status[0]).to eq(true)
    	expect(status[1]).to eq("Can't be blank")

    	status = Call.validate_data('Full name', "")
    	expect(status[0]).to eq(true)
    	expect(status[1]).to eq("Can't be blank")    	
    end

  end
end
