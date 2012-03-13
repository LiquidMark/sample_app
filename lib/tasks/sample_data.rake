namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(name: "Admin User",
                 email: "admin@liquidautos.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
    users.each do |user|
      50.times do
        content = Faker::Lorem.sentence(5)
        user.microposts.create!(content: content)
      end 
    end
    
  end
end
