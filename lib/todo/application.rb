require 'sinatra/base'

module Todo
  class Application < Sinatra::Base

    set :root, File.realpath(File.join(File.dirname(__FILE__), '..', '..'))

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

  end
end
