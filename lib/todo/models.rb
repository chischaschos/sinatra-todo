# frozen_string_literal: true
module Todo
  module Models
    require 'todo/models/errors'
    require 'todo/models/user'
    require 'todo/models/session'
    require 'todo/models/list_item'

    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
end
