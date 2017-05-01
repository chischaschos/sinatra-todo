# frozen_string_literal: true
module Todo
  module Services
    class SessionCreator
      attr_reader :errors, :access_token

      # TODO: we don't need every parameter, only pass the required ones
      def initialize(params)
        @params = params
        @result = nil
        @errors = {}
      end

      def valid?
        if user
          create_session
        else
          @errors[:errors] = { default: 'email or password invalid' }
        end

        @errors.empty?
      end

      private

      def user
        unless @user
          user = Todo::Models::User.first(email: @params[:email])
          @user = user if user.password == @params[:password]
        end

        @user
      end

      def create_session
        # TODO: Introduce named exception
        fail 'Session could not be destroyed' if @user.session && !@user.session.destroy

        @session = Models::Session.create user: @user

        if @session.saved?
          @access_token = @session.access_token
        else
          @errors = @session.errors.to_hash
        end
      end
    end
  end
end
