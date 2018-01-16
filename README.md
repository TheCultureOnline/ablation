# README

## TODO:

### Badges

[![Maintainability](https://api.codeclimate.com/v1/badges/62983f95b64552e3da99/maintainability)](https://codeclimate.com/github/TheCultureOnline/ablation/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/TheCultureOnline/ablation/badge.svg?branch=master)](https://coveralls.io/github/TheCultureOnline/ablation?branch=master)
[![Build Status](https://travis-ci.org/TheCultureOnline/ablation.svg?branch=master)](https://travis-ci.org/TheCultureOnline/ablation)


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

To run the application, in separate tabs:

```bash
# Subspot will be coming soon to support more ful text search
# bundle exec rake sunspot:solr:run
bundle exec rails s
```


## Setting up your own

Coming soon...