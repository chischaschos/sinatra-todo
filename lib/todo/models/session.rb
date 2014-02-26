require 'securerandom'

module Todo
  module Models
    class Session
      include DataMapper::Resource

      property :access_token,      String

      belongs_to :user, 'Todo::Models::User', key: true

      validates_uniqueness_of :user

      before :create do |session|
        session.access_token = SecureRandom.uuid
      end

     def to_json
       { access_token: self.access_token }.to_json
     end

      def h_errors
        { errors: self.errors.to_hash }
      end

    end
  end
end
