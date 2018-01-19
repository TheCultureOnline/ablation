# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

pass = ENV["ADMIN_PASS"] || SecureRandom.hex(16)
email = ENV["ADMIN_EMAIL"] || "admin@localhost"
admin = User.find_or_initialize_by(email: email, username: "admin", role: :admin) do |u|
  u.password = pass
  u.password_confirmation = pass
  puts "Admin password is #{pass}"
end
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
categories[:ebooks] = Category.find_or_create_by!(name: "EBook")

release = Release.find_or_create_by(
  name: "Ubuntu Desktop",
  category_id:  categories[:software].id,
)

# 16.04 i386
torrent = Torrent.from_file(
  Rails.root.join("db", "files", "software", "ubuntu-16.04.3-desktop-i386.iso.torrent"),
  release
)
TorrentMetadatum.create!(
  torrent: torrent,
  name: "arch",
  value: "x86"
)
TorrentMetadatum.create!(
  torrent: torrent,
  name: "version",
  value: "16.04.3"
)


# 16.04 AMD64
torrent = Torrent.from_file(
  Rails.root.join("db", "files", "software", "ubuntu-16.04.3-desktop-amd64.iso.torrent"),
  release
)
TorrentMetadatum.create!(
  torrent: torrent,
  name: "arch",
  value: "x86_64"
)
TorrentMetadatum.create!(
  torrent: torrent,
  name: "version",
  value: "16.04.3"
)

# 14.04 AMD64
torrent = Torrent.from_file(
  Rails.root.join("db", "files", "software", "ubuntu-14.04.5-desktop-amd64.iso.torrent"),
  release
)
TorrentMetadatum.create!(
  torrent: torrent,
  name: "arch",
  value: "x86_64"
)
TorrentMetadatum.create!(
  torrent: torrent,
  name: "version",
  value: "14.04.5"
)

SearchField.find_or_create_by!(
  name: "year",
  kind: SearchField::kinds[:number_field_tag],
  sort_order: 0,
)
