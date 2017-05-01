# frozen_string_literal: true
require 'spec_helper'

describe Todo::Services::SessionCreator do
  let(:params) { { email: 'test@test.com', password: '123test123' } }

  let(:wrong_params) { { email: 'test@test.com', password: '123' } }

  before { Todo::Models::User.create params }

  context 'when the requested user does not exists' do
    it 'should not create a session' do
      session_creator = Todo::Services::SessionCreator.new wrong_params
      expect(session_creator).not_to be_valid
      expect(session_creator.access_token).to be_nil
      expect(session_creator.errors).not_to be_empty
    end
  end

  context 'when a session does not exists yet' do
    it 'should create a session' do
      session_creator = Todo::Services::SessionCreator.new params
      expect(session_creator).to be_valid
      expect(session_creator.access_token).not_to be_nil
      expect(session_creator.errors).to be_empty
    end
  end

  context 'when a session already exists' do
    let!(:previous_access_token) do
      Todo::Models::User.create(params)
      session_creator = Todo::Services::SessionCreator.new(params)
      expect(session_creator).to be_valid
      session_creator.access_token
    end

    it 'should create a new session' do
      session_creator = Todo::Services::SessionCreator.new params
      expect(session_creator).to be_valid
      expect(session_creator.access_token).not_to be_nil
      expect(session_creator.access_token).not_to eq previous_access_token
      expect(session_creator.errors).to be_empty
    end
  end
end
