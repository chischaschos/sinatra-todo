require 'spec_helper'

describe 'Sessions API', api: true do
  let(:params) { { email: 'test@test.com', password: '123test123' } }

  let!(:user) { Todo::Models::User.create params }

  context 'when creating sessions' do
    context 'when a session does not exists yet' do
      it 'should allow a client to create a user session' do
        post '/api/session', { user: params }

        expect(last_response).to be_json
        expect(last_response).to have_cookie 'access_token', user.session.access_token
        expect(last_response.body).to eq ''
        expect(last_response.status).to eq 200
      end
    end

    context 'when a session already exists' do
      let!(:previous_access_token) do
        session_creator = Todo::Services::SessionCreator.new(params)
        expect(session_creator.valid?).to be_true
        session_creator.access_token
      end

      it 'should delete older session and create a new one' do
        post '/api/session', { user: params }

        expect(last_response).to be_json
        expect(last_response).to have_cookie 'access_token', user.session.access_token
        expect(user.session.access_token).not_to eq previous_access_token
        expect(last_response.body).to eq ''
        expect(last_response.status).to eq 200
      end
    end
  end

  context 'when destroying sessions' do
    context 'when a session already exists' do
      let!(:session) { Todo::Services::SessionCreator.new(params) }

      it 'should allow a client to destroy a user session' do
        expect(session.valid?).to be_true

        set_cookie "access_token=#{session.access_token}"

        delete "/api/session"

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to eq ''
        expect(last_response.status).to eq 200
      end
    end
  end
end
