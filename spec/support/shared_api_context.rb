# frozen_string_literal: true
require 'rack/test'

shared_context 'shared_api_context', api: true do
  include Rack::Test::Methods

  def app
    Todo::Api
  end
end

RSpec::Matchers.define :be_json do |_expected|
  match do |actual|
    actual.headers['Content-Type'] == 'application/json'
  end
end

RSpec::Matchers.define :have_cookie do |name, value|
  match do |actual|
    actual.headers['Set-Cookie'] =~ /#{name}=#{value}/
  end
end
