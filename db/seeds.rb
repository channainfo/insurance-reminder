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