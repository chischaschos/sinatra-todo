# frozen_string_literal: true
require 'spec_helper'

describe 'Sessions API', api: true do
  let(:params) { { email: 'test@test.com', password: '123test123' } }

  let!(:user) { Todo::Models::User.create params }

  context 'when creating sessions' do
    context 'when a session does not exists yet' do
      it 'should allow a client to create a user session' do
        post '/api/session', user: params

        expect(last_response).to be_json
        expect(last_response).to have_cookie 'access_token', user.session.access_token
        expect(last_response.body).to eq '{}' # so it gets recognized as a valid json response
        expect(last_response.status).to eq 200
      end
    end

    context 'when a session already exists' do
      let!(:previous_access_token) do
        session_creator = Todo::Services::SessionCreator.new(params)
        expect(session_creator).to be_valid
        session_creator.access_token
      end

      it 'should delete older session and create a new one' do
        post '/api/session', user: params

        expect(last_response).to be_json
        expect(last_response).to have_cookie 'access_token', user.session.access_token
        expect(user.session.access_token).not_to eq previous_access_token
        expect(last_response.body).to eq '{}' # so it gets recognized as a valid json response
        expect(last_response.status).to eq 200
      end
    end
  end

  context 'when destroying sessions' do
    context 'when a session already exists' do
      let!(:session) { Todo::Services::SessionCreator.new(params) }

      it 'should allow a client to destroy a user session' do
        expect(session).to be_valid

        set_cookie "access_token=#{session.access_token}"

        delete "/api/session"

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to eq ''
        expect(last_response.status).to eq 200
      end
    end
  end

  context 'when retrieving the existing session' do
    let!(:session) { Todo::Services::SessionCreator.new(params) }

    it 'should success' do
      expect(session).to be_valid

      set_cookie "access_token=#{session.access_token}"

      get "/api/session"

      expect(last_response).to be_json
      expect(last_response).not_to have_cookie 'access_token'
      expect(last_response.body).to have_json_path 'access_token'
      expect(last_response.status).to eq 200
    end
  end
end
