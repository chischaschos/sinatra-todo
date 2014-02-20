require 'spec_helper'

describe 'Sessions API', api: true do

  it 'should allow a client to create a user session' do
    params = { email: 'test@test.com', password: '123test123' }
    user = Todo::Models::User.create params

    post '/api/session', { user: params }

    expect(last_response.headers['Content-Type']).to eq 'application/json;charset=utf-8'
    expect(last_response.headers['Set-Cookie']).to match /access_token=#{user.session.access_token}/
    expect(last_response.body).to eq ''
    expect(last_response.status).to eq 200
  end

  it 'should allow a client to destroy a user session' do
    params = { email: 'test@test.com', password: '123test123' }
    Todo::Models::User.create params
    session = Todo::Services::SessionCreator.new(params)
    expect(session.valid?).to be_true

    set_cookie "access_token=#{session.access_token}"

    delete "/api/session"

    expect(last_response.headers['Content-Type']).to eq 'application/json;charset=utf-8'
    expect(last_response.headers['Set-Cookie']).to be_nil
    expect(last_response.body).to eq ''
    expect(last_response.status).to eq 200

  end
end
