FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user_#{n}"}
    password "1234567"
    name "Reminder"
  end

end
