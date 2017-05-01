# frozen_string_literal: true
require 'bcrypt'

module Todo
  module Models
    class User
      include DataMapper::Resource
      include BCrypt
      include Errors

      property :id,             Serial
      property :email,          String
      property :password_hash,  String, length: 250

      has 1, :session, 'Todo::Models::Session'
      has n, :list_items, 'Todo::Models::ListItem'

      validates_presence_of :email
      validates_format_of :email, as: :email_address
      validates_uniqueness_of :email
      validates_with_block :password do
        password_hash || [false, 'Invalid Password']
      end

      def initialize(*args)
        super(*args)
        self.password = args.first && args.first[:password]
      end

      def password
        @password ||= Password.new(password_hash)
      end

      def password=(new_password)
        if valid_password?(new_password)
          @password = Password.create(new_password)
          self.password_hash = @password
        end
      end

      def to_json
        { id: id }.to_json
      end

      private

      def valid_password?(new_password)
        new_password && new_password.size > 5
      end
    end
  end
end
