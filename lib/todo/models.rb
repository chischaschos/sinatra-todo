module Todo
  module Models

    require 'todo/models/user'
    require 'todo/models/session'

    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
end
