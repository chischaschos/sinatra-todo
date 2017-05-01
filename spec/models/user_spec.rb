# frozen_string_literal: true
require 'spec_helper'

describe Todo::Models::User do
  context 'when validating the password' do
    it 'should need a password' do
      expect(subject).not_to be_valid
      expect(subject.errors.to_hash.keys).to eq([:email, :password])
    end

    it 'should not accept empty passwords' do
      user = Todo::Models::User.new password: ''
      expect(user).not_to be_valid
      expect(user.errors.to_hash.keys).to eq([:email, :password])
    end

    it 'should not accept passwords with less than 6 characters' do
      user1 = Todo::Models::User.new password: '12345'
      expect(user1).not_to be_valid
      expect(user1.errors.to_hash.keys).to eq([:email, :password])

      user2 = Todo::Models::User.new password: '123456'
      expect(user2).not_to be_valid
      expect(user2.errors.to_hash.keys).to eq([:email])
    end
  end
end
