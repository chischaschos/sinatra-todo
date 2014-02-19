DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{File.join(Todo::Application.root, 'todos.db')}")
