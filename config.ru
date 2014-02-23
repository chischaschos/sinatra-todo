$LOAD_PATH << File.expand_path('lib')

require 'todo'

map '/assets' do
  environment =  Sprockets::Environment.new Todo::Application.root
  environment.append_path 'vendor/js'
  environment.append_path 'assets/js'
  run environment
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :put, :delete]
  end
end

use Todo::Api
run Todo::Frontend
