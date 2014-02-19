require 'rack/test'

shared_context 'shared_api_context', api: true do
  include Rack::Test::Methods

  def app
    Todo::Application
  end

end
