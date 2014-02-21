require 'spec_helper'

describe Todo::Services::SessionCreator do

  let(:params) { { email: 'test@test.com', password: '123test123' } }

  context 'when a session does not exists yet' do
    before { Todo::Models::User.create params }

    it 'should create a session' do
      session_creator = Todo::Services::SessionCreator.new params
      expect(session_creator.valid?).to be_true
      expect(session_creator.access_token).not_to be_nil
      expect(session_creator.h_errors[:errors]).to be_empty
    end
  end

  context 'when a session already exists' do
    before do
      Todo::Models::User.create(params)
      session_creator = Todo::Services::SessionCreator.new(params)
      expect(session_creator.valid?).to be_true
    end

    it 'should not create a session' do
      session_creator = Todo::Services::SessionCreator.new params
      expect(session_creator.valid?).not_to be_true
      expect(session_creator.access_token).to be_nil
      expect(session_creator.h_errors[:errors]).not_to be_empty
    end
  end
end
