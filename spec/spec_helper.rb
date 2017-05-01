# frozen_string_literal: true
$LOAD_PATH << File.expand_path('lib')

ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.require(:test)

SimpleCov.start

require 'todo'

DatabaseCleaner[:data_mapper].strategy = :truncation

Dir[File.join(Todo::Application.root, 'spec', 'support', '*')].each do |file|
  require file
end

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.clean
  end
end
