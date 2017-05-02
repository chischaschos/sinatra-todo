# frozen_string_literal: true
require 'sinatra/base'

module Todo
  class Application < Sinatra::Base
    set :root,            File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    set :logging,         true
    set :dump_errors,     false
    set :raise_errors,    true
    set :show_exceptions, false

    configure :development, :test do
      set :logger, MyLogger.new
      DataMapper::Logger.new(logger, :debug)

      file_name = File.join(Todo::Application.root, 'db', "todos-#{settings.environment}.db")
      DataMapper.setup(:default, "sqlite://#{file_name}")
    end

    configure :production do
      set :logger, Logger.new(STDOUT)
      DataMapper::Logger.new(STDOUT, :info)

      DataMapper.setup(:default, ENV['DATABASE_URL'])
    end

    use Rack::CommonLogger, settings.logger
    use Middlewares::ExceptionHandling
  end
end
