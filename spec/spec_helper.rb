$LOAD_PATH << File.expand_path('lib')

require 'todo'
require 'database_cleaner'
require 'json_spec'

DatabaseCleaner[:data_mapper].strategy = :truncation

Dir[File.join(Todo::Application.root, 'spec', 'support', '*')].each do |file|
  require file
end

RSpec.configure do |config|

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
