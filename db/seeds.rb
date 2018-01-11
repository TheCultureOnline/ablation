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

tv = Category.find_or_create_by!(name: "TV Shows")

music = Category.find_or_create_by!(name: "Music")
begin # Add metadata for Music
  music.category_metadata.find_or_create_by!(
    sort_order: 0,
    name: "Artists",
    data_type: CategoryMetadatum.data_types[:array])
  music.category_metadata.find_or_create_by!(
    sort_order: 1,
    name: "Album Title",
    data_type: CategoryMetadatum.data_types[:string])
  music.category_metadata.find_or_create_by!(
    sort_order: 2,
    name: "Year",
    description: "Year of original release",
    data_type: CategoryMetadatum.data_types[:integer])
  music.category_metadata.find_or_create_by!(
    sort_order: 3,
    name: "Record label",
    optional: true,
    data_type: CategoryMetadatum.data_types[:string])
  music.category_metadata.find_or_create_by!(
    sort_order: 4,
    name: "Catalogue number",
    optional: true,
    data_type: CategoryMetadatum.data_types[:string])
  music.category_metadata.find_or_create_by!(
    sort_order: 5,
    name: "Release Type",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        Album
        Soundtrack
        EP
        Anthology
        Compilation
        Single
        Live album
        Remix
        Bootleg
        Interview
        Mixtape
        Unknown
    ))
  music.category_metadata.find_or_create_by!(
    sort_order: 6,
    name: "Edition information",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: "Check this box if this torrent is a different release to the original, for example a limited or country specific edition or a release that includes additional bonus tracks or is a bonus disc.")
  music.category_metadata.find_or_create_by!(
    sort_order: 7,
    name: "Scene",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: 'Select this only if this is a "scene release".
If you ripped it yourself, it is not a scene release. If you are not sure, do not select it; you will be penalized. For information on the scene, visit Wikipedia.')
  music.category_metadata.find_or_create_by!(
    sort_order: 8,
    name: "Format",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        MP3
        FLAC
        Ogg\ Vorbis
        AAC
        AC3
        DTS
    ))
  # music.category_metadata.find_or_create_by!(name: "Log files")
  # music.category_metadata.find_or_create_by!(name: "Multi-format uploader")
  music.category_metadata.find_or_create_by!(
    sort_order: 9,
    name: "Vanity House",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: "Check this only if you are submitting your own work or submitting on behalf of the artist, and this is intended to be a Vanity House release. Checking this will also automatically add the group as a recommendation.")
  music.category_metadata.find_or_create_by!(
    sort_order: 10,
    name: "Media",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        CD
        DVD
        Vinyl
        Soundboard
        SACD
        DAT
        Cassette
        WEB
    ))
  music.category_metadata.find_or_create_by!(
    sort_order: 11,
    name: "Bitrate",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        192
        APS (VBR)
        V2 (VBR)
        V1 (VBR)
        256
        APX (VBR)
        V0 (VBR)
        q8.x (VBR)
        320
        Lossless
        24bit Lossless
        Other
    ))
  music.category_metadata.find_or_create_by!(
    sort_order: 12,
    name: "Image",
    data_type: CategoryMetadatum.data_types[:string],
    optional: true)
  music.category_metadata.find_or_create_by!(
    sort_order: 13,
    name: "Album description",
    data_type: CategoryMetadatum.data_types[:text],
    description: "Contains background information such as album history and maybe a review.")
  music.category_metadata.find_or_create_by!(
    sort_order: 14,
    name: "Release description",
    optional: true,
    data_type: CategoryMetadatum.data_types[:text],
    description: "Contains information like encoder settings or details of the ripping process. Do not paste the ripping log here.")
end # Music

movies = Category.find_or_create_by!(name: "Movies")

begin # Add metadata for Movies
  movies.category_metadata.find_or_create_by!(
    sort_order: 0,
      name: "Movie Title",
      data_type: CategoryMetadatum.data_types[:string])
  movies.category_metadata.find_or_create_by!(
    sort_order: 1,
    name: "IMDb Link",
    data_type: CategoryMetadatum.data_types[:string])
  movies.category_metadata.find_or_create_by!(
    sort_order: 2,
    name: "Artists",
    data_type: CategoryMetadatum.data_types[:array])
  movies.category_metadata.find_or_create_by!(
    sort_order: 3,
    name: "Year",
    description: "Year of original release",
    data_type: CategoryMetadatum.data_types[:integer])
  movies.category_metadata.find_or_create_by!(
    sort_order: 4,
    name: "Cover Art",
    data_type: CategoryMetadatum.data_types[:string])
  movies.category_metadata.find_or_create_by!(
    sort_order: 5,
    name: "YouTube Trailer",
    data_type: CategoryMetadatum.data_types[:string])
  movies.category_metadata.find_or_create_by!(
    sort_order: 6,
    name: "Not main movie",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: "Check this only if it does NOT contain the main movie.
Examples: ONLY contains extras, Rifftrax, Workprints. ")
  movies.category_metadata.find_or_create_by!(
    sort_order: 7,
    name: "Edition information",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: "Check this box if this torrent has extra edition information.
Examples: Part of a collection, special edition, or non-standard rip feature.")
  movies.category_metadata.find_or_create_by!(
    sort_order: 8,
    name: "Personal rip",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: "Check this only if you made this rip.")
  movies.category_metadata.find_or_create_by!(
    sort_order: 9,
    name: "Scene",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: 'Select this only if this is a "scene release".
If you ripped it yourself, it is not a scene release. If you are not sure, do not select it; you will be penalized. For information on the scene, visit Wikipedia.')
  movies.category_metadata.find_or_create_by!(
    sort_order: 10,
    name: "Source",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        Blu-ray
        DVD
        WEB
        HD-DVD
        HDTV
        TV
        VHS
        Other
    ))
  movies.category_metadata.find_or_create_by!(
    sort_order: 11,
    name: "Vanity House",
    data_type: CategoryMetadatum.data_types[:boolean],
    description: "Check this only if you are submitting your own work or submitting on behalf of the artist, and this is intended to be a Vanity House release. Checking this will also automatically add the group as a recommendation.")
  movies.category_metadata.find_or_create_by!(
    sort_order: 12,
    name: "Media",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        CD
        DVD
        Vinyl
        Soundboard
        SACD
        DAT
        Cassette
        WEB
    ))
  movies.category_metadata.find_or_create_by!(
    sort_order: 13,
    name: "Bitrate",
    data_type: CategoryMetadatum.data_types[:string],
    options: %w(
        192
        APS (VBR)
        V2 (VBR)
        V1 (VBR)
        256
        APX (VBR)
        V0 (VBR)
        q8.x (VBR)
        320
        Lossless
        24bit Lossless
        Other
    ))
  movies.category_metadata.find_or_create_by!(
    sort_order: 14,
    name: "Image",
    data_type: CategoryMetadatum.data_types[:string],
    optional: true)
  movies.category_metadata.find_or_create_by!(
    sort_order: 15,
    name: "Synopsis",
    data_type: CategoryMetadatum.data_types[:text])
  movies.category_metadata.find_or_create_by!(
    sort_order: 16,
    name: "Release description",
    optional: true,
    data_type: CategoryMetadatum.data_types[:text])
  movies.category_metadata.find_or_create_by!(
    sort_order: 17,
    name: "Subtitles",
    data_type: CategoryMetadatum.data_types[:array],
    options: %w(
        English Spanish French English\ -\ Forced
        English\ Intertitles Arabic Brazilian\ Port.
        Bulgarian Chinese Croatian Czech Danish Dutch
        Estonian Finnish German Greek Hebrew Hindi
        Hungarian Icelandic Indonesian Italian
        Japanese Korean Latvian Lithuanian Norwegian
        Persian Polish Portuguese Romanian Russian
        Serbian Slovak Slovenian Swedish Thai Turkish
        Ukrainian Vietnamese
    )
  )
end # Movies
