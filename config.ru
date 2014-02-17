$LOAD_PATH << File.expand_path('lib')

require 'todo'


Todo::Application.root = File.realpath(File.dirname(__FILE__))

map '/assets' do
  environment =  Sprockets::Environment.new Todo::Application.root
  environment.append_path 'vendor/js'
  environment.append_path 'assets/js'
  run environment
end


run Todo::Application
