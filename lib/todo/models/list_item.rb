# frozen_string_literal: true
module Todo
  module Models
    class ListItem
      include DataMapper::Resource
      include Errors

      property :id,           Serial
      property :description,  String
      property :priority,     Integer
      property :completed,    Boolean
      property :due_date,     Date

      belongs_to :user, 'Todo::Models::User'

      validates_presence_of :description
    end
  end
end
