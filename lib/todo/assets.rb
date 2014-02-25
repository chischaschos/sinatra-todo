module Todo
  module Assets
    def self.environment
      environment =  Sprockets::Environment.new Todo::Application.root
      environment.append_path 'vendor'
      environment.append_path 'assets/js'
      environment.append_path 'assets/css'
      environment
    end
  end
end
