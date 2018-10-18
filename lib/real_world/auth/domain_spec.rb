# frozen_string_literal: true

require 'securerandom'
require 'real_world/auth/domain'

describe RealWorld::Auth::Domain do
  let(:user_id) { SecureRandom.uuid }
  let(:password) { 'some_password' }

  describe '.create_credentials' do
    subject { described_class.create_credentials(user_id, password) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(user_id: user_id, password: be_a(String), salt: be_a(String)),
            events: [:auth_credentials_created],
          ),
        )
      }
    end

    [nil, 1, 'a', '@', 'a@'].each do |invalid_user_id|
      context "when the user_id is '#{invalid_user_id}'" do
        let(:user_id) { invalid_user_id }
        it { is_expected.to fail_with_errors(:user_id_is_invalid) }
      end
    end

    [nil, '1', '123', '123456', 'a' * 100].each do |invalid_password|
      context "when the password is '#{invalid_password}'" do
        let(:password) { invalid_password }
        it { is_expected.to fail_with_errors(:password_is_invalid) }
      end
    end
  end

  describe '.match?' do
    let(:credentials) { described_class.create_credentials(user_id, password).fetch(:data) }
    subject { described_class.match?(credentials, entered_password) }

    context 'when the password matches' do
      let(:entered_password) { password }
      it { is_expected.to be(true) }
    end

    context 'when the password does not match' do
      let(:entered_password) { 'invalid!' }
      it { is_expected.to be(false) }
    end
  end
end
