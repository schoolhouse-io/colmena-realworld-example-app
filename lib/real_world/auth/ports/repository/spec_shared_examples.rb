# frozen_string_literal: true

require 'securerandom'

RSpec.shared_examples 'an auth repository' do
  before { subject.clear }

  let(:credentials) do
    { user_id: SecureRandom.uuid, password: 'password_hash', salt: 'random' }
  end

  context 'when there are no credentials stored' do
    it '#create' do
      expect { subject.create(credentials) }.not_to raise_error
    end

    it '#read_by_user_id' do
      expect(subject.read_by_user_id(credentials.fetch(:user_id))).to be(nil)
    end
  end

  context 'when a user has some credentials' do
    before { subject.create(credentials) }

    it '#create credentials for the same user_id' do
      new_credentials = credentials.merge(password: rand(100))
      expect { subject.create(new_credentials) }.to raise_error(StandardError)
    end

    it '#read_by_user_id' do
      expect(subject.read_by_user_id(credentials.fetch(:user_id))).to include(credentials)
    end

    it '#delete' do
      expect(subject.delete(credentials.fetch(:user_id))).to eq(1)
      expect(subject.read_by_user_id(credentials.fetch(:user_id))).to be(nil)
    end
  end
end
