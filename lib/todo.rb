require 'bundler'

Bundler.require :default

module Todo
  autoload :Api, 'todo/api'
  autoload :Frontend, 'todo/frontend'
  autoload :Application, 'todo/application'
  autoload :Models, 'todo/models'
  autoload :Services, 'todo/services'
  autoload :Middlewares, 'todo/middlewares'
  autoload :MyLogger, 'todo/my_logger'
end
