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
        random = ('a'..'z').to_a.shuffle[0,8].join
        title = "#{random}"
        url   = "http://google.com/#{random}"
        user_id = u.id
        Post.create!(title:   title,
                     url:     url,
                     user_id: u.id)
      end
    end

    # create random upvotes
    User.all.each do |u|
      uppost = Post.find(rand(15) + 1)
      downpost = Post.find(rand(5) + 5)
      Vote.vote_thusly_on_post_or_comment_for_user_because(1, uppost.id,
        nil, u.id, nil)
      if ((rand(2) + 1) % 2 == 0)
        Vote.vote_thusly_on_post_or_comment_for_user_because(-1, downpost.id,
          nil, u.id, nil)
      end
    end
  end
end