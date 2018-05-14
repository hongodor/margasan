# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
storage_files = Dir.glob( File.join(Rails.root, "storage", "*") )
File.delete(*storage_files)

User.create!(username: "test",
             email: "admin@test.com",
             password: "64014011",
             role: 1)

5.times do
  User.create!(username: Faker::Internet.user_name,
               email: Faker::Internet.email,
               password: Faker::Internet.password)
end

6.times do
  Project.create(name: Faker::Book.title,
                 description: Faker::Lorem.paragraph,
                 author: Faker::Book.author,
                 user: User.all.sample)
end
20.times do
  Chapter.create(name: Faker::Book.title,
                 filename: Faker::File.file_name,
                 status: rand(3),
                 project: Project.all.sample,
                 user: User.all.sample)
end
