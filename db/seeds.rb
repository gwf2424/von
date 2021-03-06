# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name:  "gwf2",
                 email: "example@railstutorial.org",
                 password:              "111111",
                 password_confirmation: "111111",
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)
99.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name: name,
                   email: email,
                   password:              password,
                   password_confirmation: password,
                   activated: true,
                   activated_at: Time.zone.now)
end

Setting.create!(isUseMail: false, isPicMicropost: false)

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(content: content) # 也可以这么来{ |user| user.microposts.create!(content: content)}
  end
end

#following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each{ |followed| user.follow(followed)}
followers.each{ |follower| follower.follow(user)}


Product.delete_all

3.times do |n|
  title = "Title#{n}"
  description = "Desc#{n}"
  image_url = "p#{n}.jpg"
  Product.create!(title: title, description: description, image_url: image_url, price: price)
end