# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default user

user_attrs = { username: 'admin', password: '123456', name: 'Admin' }

user = User.where(username: user_attrs[:username]).first_or_initialize
user.update_attributes(user_attrs)


client_attrs = [
  {phone_number: '0975553553', family_code: '1234-984763-09810', expiration_date: '2015-03-10'},
  {phone_number: '069860012', family_code: '1234-984763-09811', expiration_date: '2015-05-10'},
  {phone_number: '077777457', family_code: '1234-984763-09812', expiration_date: '2015-07-10'},
  {phone_number: '1000', family_code: '1234-984763-09813', expiration_date: '2015-09-10'}
]

client_attrs.each do |attrs|
  client = Client.where(phone_number: attrs[:phone_number]).first_or_initialize
  client.update_attributes(attrs)
end

