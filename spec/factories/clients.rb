FactoryGirl.define do
  factory :client do
    sequence(:beneficiary_id) { |n| n }
    sequence(:phone_number) {|n| "09755535#{n}"}
    sequence(:family_code) { |n| "123#{n}-12345#{n}-1234#{n}"}
    expiration_date "2015-02-05"
  end

end
