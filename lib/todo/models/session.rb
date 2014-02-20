require 'securerandom'

module Todo
  module Models
    class Session
      include DataMapper::Resource

      property :access_token,      String

      belongs_to :user, 'Todo::Models::User', key: true

      before :create do |session|
        session.access_token = SecureRandom.uuid
      end

    end
  end
end
