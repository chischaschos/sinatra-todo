require 'spec_helper'

describe 'Sessions API', api: true do

  it 'a user can create a session' do
    params = { email: 'test@test.com', password: '123test123' }
    user = Todo::Models::User.create! params

    post '/api/sessions', { user: params }

    expect(last_response.headers['Content-Type']).to eq 'application/json;charset=utf-8'
    expect(last_response.headers['Set-Cookie']).to match /access_token/
    expect(last_response.body).to eq ''
    expect(last_response.status).to eq 200
  end
end
