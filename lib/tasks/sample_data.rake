namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do

    Rake::Task['db:reset'].invoke

    User.create!(username: 'ExampleUser',
                 email: 'example@user.com',
                 password: 'foobarfoobar',
                 password_confirmation: 'foobarfoobar')
    20.times do |n|
      username = Faker::Internet.user_name
      email = "test-#{n+1}@test.org"
      password = "password"
      u = User.create!(username: username,
                   email: email,
                   password: password,
                   password_confirmation: password)

      (0..5).each do |i|
        title = "Hello World 1-#{i}"
        url   = "http://google.com/#{i}"
        user_id = u.id
        Post.create!(title:   title,
                     url:     url,
                     user_id: u.id)
      end
    end
  end
end