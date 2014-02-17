require 'sinatra/base'

module Todo
  class Application < Sinatra::Base

    get '/' do
      haml :index
    end

  end
end
