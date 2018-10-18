# frozen_string_literal: true

require 'securerandom'
require 'real_world/auth/ports/spec_shared_context'
require 'real_world/auth/commands/create_auth_credentials'

describe RealWorld::Auth::Commands::CreateAuthCredentials do
  include_context 'auth ports'

  let(:user_id) {  SecureRandom.uuid }
  let(:password) { 'some_password' }

  let(:command) { described_class.new(ports) }
  subject { command.call(user_id: user_id, password: password) }

  context 'when the credentials do not exist' do
    it {
      is_expected.to(
        succeed(
          data: include(:user_id, :password, :salt),
          events: [:auth_credentials_created],
        ),
      )
    }

    context 'when the credentials are invalid' do
      let(:user_id) { 'invalid' }
      it { is_expected.to fail_with_errors(:user_id_is_invalid) }
    end
  end

  context 'when the credentials already exist' do
    before { repository.create(user_id: user_id, password: 'some_hash', salt: 'random') }
    it { is_expected.to fail_with_errors(:credentials_already_exist) }
  end
end
