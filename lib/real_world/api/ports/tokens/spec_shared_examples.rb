# frozen_string_literal: true

require 'securerandom'
require 'timecop'

RSpec.shared_examples 'a token manager' do
  let(:email) { 'some@email.com' }

  describe 'auth token' do
    let(:user_id) { 'some-user-id' }

    it 'encodes and decodes auth data' do
      auth_token = subject.auth(email, user_id)
      data, error = subject.decode_auth(auth_token)

      expect(error).to be(nil)
      expect(data).to include(email: email, user_id: user_id)
    end

    it 'returns tokens that expire in less than a day' do
      auth_token = subject.auth(email, user_id)

      Timecop.freeze(Time.at(Time.now.to_i + 60 * 60 * 24)) do
        data, error = subject.decode_auth(auth_token)

        expect(error).to be(:expired_token)
        expect(data).to be(nil)
      end
    end

    describe 'decoding garbage' do
      it 'returns an error' do
        data, error = subject.decode_auth(SecureRandom.hex)

        expect(error).to be(:invalid_token)
        expect(data).to be(nil)
      end
    end
  end
end
