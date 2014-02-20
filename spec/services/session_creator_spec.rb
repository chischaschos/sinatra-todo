require 'spec_helper'

describe Todo::Services::SessionCreator do

  it 'successfully creates a session for an existing user' do
    params = { email: 'test@test.com', password: '123test123' }
    user = Todo::Models::User.create! params
    session_creator = Todo::Services::SessionCreator.new params
    expect(session_creator.valid?).to be_true
    expect(session_creator.access_token).not_to be_nil
    expect(session_creator.errors).not_to be_nil
  end

end
