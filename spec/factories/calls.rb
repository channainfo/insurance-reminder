FactoryGirl.define do
  factory :call do
    client
    main nil
    status Call::STATUS_PENDING
    expired_date "2015-02-11"
    phone_number "MyString"
    update_status_at "2015-02-11 11:21:51"
  end
end
