# frozen_string_literal: true
require 'spec_helper'

describe 'Users API', api: true do
  context 'when creating users' do
    it 'should create a user with email and password' do
      expect(Todo::Models::User.count).to eq 0

      post '/api/users', user: { email: 'test@test.com', password: '123test123' }

      expect(last_response).to be_json

      expect(last_response.body).to have_json_path 'id'
      expect(last_response.body).not_to have_json_path 'email'
      expect(last_response.body).not_to have_json_path 'password'

      expect(last_response.status).to eq 200

      expect(Todo::Models::User.count).to eq 1
    end

    it 'should fail if missing password' do
      expect(Todo::Models::User.count).to eq 0

      post '/api/users', user: { email: 'test@test.com' }

      expect(last_response).to be_json
      expect(last_response.body).to have_json_path 'errors/password'
      expect(last_response.status).to eq 404
      expect(Todo::Models::User.count).to eq 0
    end
  end
end
