require 'logger'

module Todo
  class MyLogger < Logger
    alias_method :write, :<<

    def initialize
      super File.join(Todo::Application.root, 'log', 'app.log')
    end
  end
end
