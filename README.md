# README

## TODO:

### Badges

- codeclimate
- coveralls (github)
- ci / migrate to travis (github)

### Search

Solr will be fully integrated soon, allowing true full text search of torrents.

## Getting started

Ablation is developed (primarily) and tested with Ruby 2.5.

If you would like to pre-seed an admin password, you can set `ADMIN_PASS`; otherwise, a random password will be generated and presented on seed

```bash
bundle install
bundle exec rails db:create db:schema:load db:seed
```

The test suite can be run with:

```bash
bundle exec rails test
```

## Setting up your own

Coming soon...