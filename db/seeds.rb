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

Announcement.find_or_create_by!(
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

categories.each do |name, cat|
  ["year"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: cat,
      name: t,
      field_type: CategoryMetadataType.field_types[:number_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release]
    )
  end

  ["publisher"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: cat,
      name: t,
      field_type: CategoryMetadataType.field_types[:text_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release]
    )
  end
end

# EBooks
begin
  [].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:ebooks],
      name: t,
      field_type: CategoryMetadataType.field_types[:number_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release]
    )
  end

  [].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:ebooks],
      name: t,
      field_type: CategoryMetadataType.field_types[:number_field],
      metadata_for: CategoryMetadataType.metadata_fors[:torrent]
    )
  end

  ["format"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:ebooks],
      name: t,
      field_type: CategoryMetadataType.field_types[:text_field],
      metadata_for: CategoryMetadataType.metadata_fors[:torrent]
    )
  end
end

# Sotfware
begin
  ["version"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:software],
      name: t,
      field_type: CategoryMetadataType.field_types[:text_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release]
    )
  end

  [["arch", ["x86", "x84_64", "ARM"]],].each do |t, options|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:software],
      name: t,
      field_type: CategoryMetadataType.field_types[:select_field],
      metadata_for: CategoryMetadataType.metadata_fors[:torrent],
      options: options
    )
  end

  u1604 = Release.find_or_create_by(
    name: "Ubuntu 16.4.3 Desktop",
    category_id:  categories[:software].id,
  )

  ReleaseMetadatum.find_or_create_by!(
    release: u1604,
    name: "year",
    value: "2016"
  )

  ReleaseMetadatum.find_or_create_by!(
    release: u1604,
    name: "version",
    value: "16.04.3"
  )

  ReleaseMetadatum.find_or_create_by!(
    release: u1604,
    name: "publisher",
    value: "Canonical"
  )

  # 16.04 i386
  torrent = Torrent.from_file(
    Rails.root.join("db", "files", "software", "ubuntu-16.04.3-desktop-i386.iso.torrent"),
    u1604
  )


  TorrentMetadatum.find_or_create_by!(
    torrent: torrent,
    name: "arch",
    value: "x86"
  )

  # 16.04 AMD64
  torrent = Torrent.from_file(
    Rails.root.join("db", "files", "software", "ubuntu-16.04.3-desktop-amd64.iso.torrent"),
    u1604
  )
  TorrentMetadatum.find_or_create_by!(
    torrent: torrent,
    name: "arch",
    value: "x86_64"
  )

  u1404 = Release.find_or_create_by(
    name: "Ubuntu 14.04.3 Desktop",
    category_id:  categories[:software].id,
  )

  ReleaseMetadatum.find_or_create_by!(
    release: u1404,
    name: "year",
    value: "2014"
  )

  ReleaseMetadatum.find_or_create_by!(
    release: u1404,
    name: "publisher",
    value: "Canonical"
  )

  # 14.04 AMD64
  torrent = Torrent.from_file(
    Rails.root.join("db", "files", "software", "ubuntu-14.04.5-desktop-amd64.iso.torrent"),
    u1404
  )

  TorrentMetadatum.find_or_create_by!(
    torrent: torrent,
    name: "arch",
    value: "x86_64"
  )

  TorrentMetadatum.find_or_create_by!(
    torrent: torrent,
    name: "version",
    value: "14.04.5"
  )
end

# Movies
begin
  [].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:movies],
      name: t,
      field_type: CategoryMetadataType.field_types[:number_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release]
    )
  end

  ["cover art", "youtube trailer"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:movies],
      name: t,
      field_type: CategoryMetadataType.field_types[:text_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release]
    )
  end

  ["scene", "personal rip"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:movies],
      name: t,
      field_type: CategoryMetadataType.field_types[:text_field],
      metadata_for: CategoryMetadataType.metadata_fors[:torrent]
    )
  end
  [
    ["type", ["Feature Film", "Short Film", "Miniseries", "Stand-up Comedy", "Live Performance", "Movie Collection"]],
    ["source", ["Blu-ray", "DVD", "WEB", "HD-DVD", "HDTV", "TV", "VHS", "Other"]],
  ].each do |t, opts|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:movies],
      name: t,
      field_type: CategoryMetadataType.field_types[:select_field],
      metadata_for: CategoryMetadataType.metadata_fors[:release],
      options: opts
    )
  end

  [].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:movies],
      name: t,
      field_type: CategoryMetadataType.field_types[:number_field],
      metadata_for: CategoryMetadataType.metadata_fors[:torrent]
    )
  end

  ["format"].each do |t|
    CategoryMetadataType.find_or_create_by!(
      category: categories[:movies],
      name: t,
      field_type: CategoryMetadataType.field_types[:text_field],
      metadata_for: CategoryMetadataType.metadata_fors[:torrent]
    )
  end
end

SearchField.find_or_create_by!(
  name: "year",
  kind: SearchField.kinds[:number_field_tag],
  sort_order: 0,
  search_type: SearchField.search_types[:release],
)

SearchField.find_or_create_by!(
  name: "publisher",
  kind: SearchField.kinds[:text_field_tag],
  sort_order: 1,
  search_type: SearchField.search_types[:release],
)

SearchField.find_or_create_by!(
  name: "scene",
  kind: SearchField.kinds[:check_box_tag],
  sort_order: 2,
  category: categories[:movies],
  search_type: SearchField.search_types[:torrent],
)

SearchField.find_or_create_by!(
  name: "arch",
  kind: SearchField.kinds[:select_tag],
  sort_order: 3,
  category: categories[:software],
  search_type: SearchField.search_types[:torrent],
  options: ["x86", "x86_64", "ARM"]
)
