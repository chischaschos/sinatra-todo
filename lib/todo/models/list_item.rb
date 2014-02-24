module Todo
  module Models
    class ListItem
      include DataMapper::Resource

      property :id,           Serial
      property :description,  String
      property :priority,     Integer
      property :completed,    Boolean
      property :due_date,     Date

      belongs_to :user, 'Todo::Models::User'

      validates_presence_of :description

      def h_errors
        { errors: self.errors.to_hash }
      end

    end
  end
end
