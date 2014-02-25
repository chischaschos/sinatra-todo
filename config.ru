$LOAD_PATH << File.expand_path('lib')

require 'todo'

map '/assets' do
  run Todo::Assets.environment
end

use Todo::Api

run Todo::Frontend
