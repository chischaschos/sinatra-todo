module Todo
  module Services
    class SessionCreator

      def initialize(params)
        @params = params
        @result = nil
      end

      def valid?
        !!user
      end

      def access_token
        user && !@session && create_session
        @access_token
      end

      def errors
        { password: 'email or password invalid' }
      end

      private

      def user
        @user ||= Todo::Models::User.first(email: @params[:email],
                                 password: @params[:password])
      end

      def create_session
        @session = Models::Session.create user: @user
        if @session.saved?
          @access_token = @session.access_token
        else
          fail 'Session could not be created'
        end
      end

    end
  end
end
