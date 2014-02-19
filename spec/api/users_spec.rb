require 'spec_helper'

describe 'Users API', api: true do

  context 'when 200 response' do
    it 'should success creating a user' do
      expect(Todo::Models::User.count).to eq 0

      params = { user: { email: 'test@test.com', password: '123test123' } }
      post '/api/users', params

      expect(last_response.headers['Content-Type']).to eq 'application/json;charset=utf-8'
      expect(last_response.body).to have_json_path 'id'
      expect(last_response.body).not_to have_json_path 'email'
      expect(last_response.body).not_to have_json_path 'password'
      expect(last_response.status).to eq 200
      expect(Todo::Models::User.count).to eq 1
    end
  end

  context 'when 404 response' do
    it 'should fail because of empty password' do
      expect(Todo::Models::User.count).to eq 0

      params = { user: { email: 'test@test.com' } }
      post '/api/users', params

      expect(last_response.headers['Content-Type']).to eq 'application/json;charset=utf-8'
      expect(last_response.body).to have_json_path 'errors/password'
      expect(last_response.status).to eq 404
      expect(Todo::Models::User.count).to eq 0
    end
  end
end
