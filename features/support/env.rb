$LOAD_PATH << File.expand_path('lib')

ENV['RACK_ENV'] = 'test'

require 'debugger'
require 'todo'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'capybara/cucumber'
require 'capybara-webkit'
require 'launchy'
require 'rspec/matchers'
require 'nokogiri'

Capybara.configure do |config|
  config.default_driver = :webkit
  config.javascript_driver = :webkit
  config.server_port = 1111
end

DatabaseCleaner[:data_mapper].strategy = :truncation

Before do |scenario, block|
  DatabaseCleaner.clean
end

#Before do
#@dummy_app_pid = fork do
#Todo::Frontend.use Todo::Api
#exec Rack::Handler::WEBrick.run Todo::Frontend, {
#Port: 1111,
#BindAddress: 'localhost',
#Logger: Todo::Frontend.logger,
#AccessLog: [
##[Rails.logger, WEBrick::AccessLog::COMMON_LOG_FORMAT]
#]
#}
#end
#end

#After do
#Process.kill 'KILL', @dummy_app_pid
#end


Capybara.app = Rack::Builder.new do
  map '/assets' do
    run Todo::Assets.environment
  end
  use Todo::Api
  run Todo::Frontend
end
