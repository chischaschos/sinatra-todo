
module Todo
  module Models
    class User
      include DataMapper::Resource

      property :id,         Serial
      property :email,      String
      property :password,   String

      validates_presence_of :email
      validates_format_of :email, as: :email_address
      validates_uniqueness_of :email

      validates_presence_of :password

      def to_json
        { id: self.id }.to_json
      end
    end

  end
end
