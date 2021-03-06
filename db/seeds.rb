# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

User.create!(username: "admin",
             email: "admin@test.com",
             password: "64014011",
             role: 1)
User.create!(username: "user",
             email: "user@test.com",
             password: "64014011",
             role: 0)
5.times do
  User.create!(username: Faker::Internet.user_name,
               email: Faker::Internet.email,
               password: Faker::Internet.password)
end

2.times do
  Project.create!(name: Faker::Book.title,
                 description: Faker::Lorem.paragraph,
                 author: Faker::Book.author,
                 user: User.all.sample)
end
=begin
FileUtils.rm_f Dir.glob("#{Rails.root}/test/files/*")
5.times do
  file = Faker::File.file_name('',nil,nil,'')
  File.new("#{Rails.root}/test/files/#{file}", "w")
  chapter = Chapter.create!(name: Faker::Book.title,
                 filename: file,
                 status: rand(3),
                 project: Project.all.sample,
                 user: User.all.sample)
  chapter.chapter_file.attach(io: File.open("#{Rails.root}/test/files/#{file}"),
                              filename: file,
                              content_type: 'application/pdf')

end
100.times do
  Phrase.create!(original: Faker::Lorem.sentences.join("\n"),
                translated: "",
                chapter: Chapter.all.sample)
end
300.times do
  user = User.all.sample
  Option.create!(content: Faker::Lorem.paragraphs.join("\n"),
                check: [0,1].sample,
                user: user,
                author: user.username,
                phrase: Phrase.all.sample)
end
=end