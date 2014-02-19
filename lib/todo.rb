require 'bundler'

Bundler.require :default

module Todo
  autoload :Application, 'todo/application'
  autoload :Models, 'todo/models'
end
