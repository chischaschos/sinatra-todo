# frozen_string_literal: true
module Todo
  module Middlewares
    class ExceptionHandling
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call env
      rescue => ex
        env['rack.errors'].puts ex
        env['rack.errors'].puts ex.backtrace.join("\n")
        env['rack.errors'].flush

        hash = { message: ex.to_s }
        hash[:backtrace] = ex.backtrace
        Todo::Application.logger.error(JSON.pretty_generate(hash))
        [500, { 'Content-Type' => 'application/json' }, [MultiJson.dump(hash)]]
      end
    end
  end
end
