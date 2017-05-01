module Todo
  module Models
    module Errors
      def error_messages
        { errors: errors.to_hash }
      end
    end
  end
end
