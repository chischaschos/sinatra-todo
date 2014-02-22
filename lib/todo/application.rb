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
        user.h_errors.to_json
      end
    end

    post '/api/session' do
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
        session.h_errors.to_json
      end
    end

    post '/api/session' do
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
        session.h_errors.to_json
      end
    end

    delete '/api/session' do
      content_type :json
      session = Models::Session.first(access_token: request.cookies['access_token'])
      if !session || session && !session.destroy
        status 404
        session.h_errors.to_json
      end
    end

    post '/api/list_item' do
      content_type :json
      session = Models::Session.first(access_token: request.cookies['access_token'])

      if session
        list_item = session.user.list_items.create(params[:list_item])

        if list_item.saved?
          list_item.to_json
        else
          status 404
          list_item.h_errors.to_json
        end

      else
        status 501
        { errors: { default: 'Invalid access token' } }.to_json
      end
    end

    put '/api/list_item/:list_item_id' do |list_item_id|
      content_type :json
      session = Models::Session.first(access_token: request.cookies['access_token'])

      if session
        list_item = session.user.list_items.get(list_item_id)
        list_item.attributes = list_item.attributes.merge(params[:list_item])

        if list_item.save
          list_item.to_json
        else
          status 404
          list_item.h_errors.to_json
        end

      else
        status 501
        { errors: { default: 'Invalid access token' } }.to_json
      end
    end

    delete '/api/list_item/:list_item_id' do |list_item_id|
      content_type :json
      session = Models::Session.first(access_token: request.cookies['access_token'])

      if session
        list_item = session.user.list_items.get(list_item_id)

        if !list_item || !list_item.destroy
          status 404
          list_item.h_errors.to_json
        end

      else
        status 501
        { errors: { default: 'Invalid access token' } }.to_json
      end
    end

  end
end
