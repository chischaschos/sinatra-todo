# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.1'

gem 'data_mapper'
gem 'rack-contrib'
gem 'rack-cors', require: 'rack/cors'
gem 'rake'
gem 'sinatra'

group 'development' do
  gem 'shotgun'
end

group :development, :test do
  gem 'dm-sqlite-adapter'
  gem 'pry-byebug'
end

group :test do
  gem 'capybara-webkit'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'simplecov'
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'pg'
end
