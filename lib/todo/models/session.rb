# frozen_string_literal: true
require 'securerandom'

module Todo
  module Models
    class Session
      include DataMapper::Resource
      include Errors

      property :access_token, String

      belongs_to :user, 'Todo::Models::User', key: true

      validates_uniqueness_of :user

      before :create do |session|
        session.access_token = SecureRandom.uuid
      end

      def to_json
        { access_token: access_token }.to_json
      end
    end
  end
end
