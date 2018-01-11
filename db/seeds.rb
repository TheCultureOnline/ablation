# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

pass = ENV["ADMIN_PASS"] || SecureRandom.hex(16)

admin = User.find_or_initialize_by(email: "admin@localhost", username: "admin", role: :admin) do |u|
  u.password = pass
  u.password_confirmation = pass
  puts "Admin password is #{pass}"
end
admin.save
admin.confirm

Announcement.create!(
  user: admin,
  title: "Welcome to the new Bittorrent tracker!",
  body: "This is a new Bittorrent tracker based on Ablation, a generic, open sourced tracker suite.",
)

categories = {}
categories[:tv] = Category.find_or_create_by!(name: "TV Shows")

categories[:music] = Category.find_or_create_by!(name: "Music")

categories[:movies] = Category.find_or_create_by!(name: "Movies")

categories[:software] = Category.find_or_create_by!(name: "Software")


[:software].each do |category_name|
  Dir.glob(Rails.root.join("db", "files", category_name.to_s, "*")).each do |path|
    Torrent.from_file(path, categories[category_name].id)
  end
end
