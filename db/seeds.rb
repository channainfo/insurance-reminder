# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default Setting
Setting[:day_before_expiration_date] = 7
Setting[:retries] = 3
Setting[:call_time] = '11:30'

# Default user

user_attrs = { username: 'admin', password: '123456', name: 'Admin', role: User::ROLE_ADMIN }

user = User.where(username: user_attrs[:username]).first_or_initialize
user.update_attributes(user_attrs)


client_attrs = [
  {phone_number: '0975553553', family_code: '1234-984763-09810', expiration_date: '2015-1-1', full_name: 'Visal', beneficiary_id: 1},
  {phone_number: '069860012', family_code: '1234-984763-09811', expiration_date: '2015-2-2', full_name: 'Kosal', beneficiary_id: 2},
  {phone_number: '077777457', family_code: '1234-984763-09812', expiration_date: '2015-3-3', full_name: 'Phirum', beneficiary_id: 3},
  {phone_number: '1000', family_code: '1234-984763-09813', expiration_date: '2015-4-4', full_name: 'Sophal', beneficiary_id: 4}
]

client_attrs.each do |attrs|
  client = Client.where(beneficiary_id: attrs[:beneficiary_id]).first_or_initialize
  client.update_attributes(attrs)
end


clients = Client.all

(0..5).each do
  client = clients[(0..3).to_a.sample]

  call = client.calls.build(expiration_date: client.expiration_date,
                            phone_number: client.phone_number,
                            family_code: client.family_code,
                            status: Call::STATUS_ERROR)
  call.save!

  (0..5).to_a.sample.times.each.each do |index|
    retry_call = client.calls.build(expiration_date: client.expiration_date,
                                    phone_number: client.phone_number,
                                    family_code: client.family_code,
                                    main: call,
                                    status: Call::STATUS_ERROR)
    retry_call.save!
  end
end
