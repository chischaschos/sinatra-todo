module Todo
  class Frontend < Application

    get '/' do
      haml :index
    end

  end
end
