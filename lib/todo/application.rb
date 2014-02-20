require 'sinatra/base'

module Todo
  class Application < Sinatra::Base

    set :root, File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    set :logging, true
    set :dump_errors, true

    configure do
      DataMapper::Logger.new($stdout, :debug)
      DataMapper.setup(:default, "sqlite://#{File.join(Todo::Application.root, 'todos.db')}")
    end

    get '/' do
      haml :index
    end

    post '/api/users' do
      content_type :json
      user = Models::User.new(params[:user])

      if user.valid?
        user.save!
        user.to_json

      else
        status 404
        { errors: user.errors.to_hash }.to_json
      end
    end

    post '/api/sessions' do
      content_type :json

      session = Services::SessionCreator.new(params[:user])

      if session.valid?
        cookie_params = {
          value: session.access_token,
          httponly: true,
          secure: true
        }
        response.set_cookie 'access_token', cookie_params

      else
        status 404
        { errors: session.errors.to_hash }.to_json
      end

    end

  end
end
