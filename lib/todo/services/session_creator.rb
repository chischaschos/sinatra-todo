# frozen_string_literal: true
module Todo
  module Services
    class SessionCreator
      attr_reader :h_errors, :access_token

      # TODO: we don't need every parameter, only pass the required ones
      def initialize(params)
        @params = params
        @result = nil
        @h_errors = { errors: {} }
      end

      def valid?
        if user
          create_session
        else
          @h_errors[:errors][:default] = 'email or password invalid'
        end

        @h_errors[:errors].empty?
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
          @h_errors.merge!(@session.h_errors)
        end
      end
    end
  end
end
