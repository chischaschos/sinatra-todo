# frozen_string_literal: true
require 'logger'

module Todo
  class MyLogger < Logger
    alias write <<

    def initialize
      super File.join(Todo::Application.root, 'log', "#{Todo::Application.environment}.log")
    end
  end
end
