require 'sinatra/base'

module Todo
  class Application < Sinatra::Base

    set :root, File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    set :logging, true
    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false
    set :logger, MyLogger.new

    configure do
      DataMapper::Logger.new(logger, :debug)
      DataMapper.setup(:default, "sqlite://#{File.join(Todo::Application.root, 'db', 'todos.db')}")
    end

    use Rack::CommonLogger, settings.logger
    use Middlewares::ExceptionHandling

  end
end
