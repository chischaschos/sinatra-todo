module Todo
  module Models
    require 'todo/models/db'
    require 'todo/models/user'

    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
end
