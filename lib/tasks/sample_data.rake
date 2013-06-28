namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    User.create!(username: 'ExampleUser',
                 email: 'example@user.com',
                 password: 'foobarfoobar',
                 password_confirmation: 'foobarfoobar')
    99.times do |n|
      username = Faker::Internet.user_name
      email = Faker::Internet.email
      password = "password"
      User.create!(username: username,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end