require 'real_world/auth/domain'
require 'real_world/auth/ports/spec_shared_context'
require 'real_world/auth/queries/check_auth_credentials'

describe RealWorld::Auth::Queries::CheckAuthCredentials do
  include_context 'auth ports'

  let(:email) {  'some@email.com' }
  let(:password) {  'some_password' }

  let(:query) { described_class.new(ports) }
  subject { query.call(email: email, password: password) }

  context 'when the credentials do not exist' do
    it {is_expected.to fail_with_errors(:credentials_do_not_match) }
  end

  context 'when the credentials do not match' do
    before { repository.create(email: email, password: 'some_hash', salt: 'random') }
    it {is_expected.to fail_with_errors(:credentials_do_not_match) }
  end

  context 'when the credentials match' do
    before do
      encrypted_credentials = RealWorld::Auth::Domain.encrypt_credentials(
        email: email, password: password,
      )
      repository.create(encrypted_credentials)
    end

    it {is_expected.to succeed(data: be(true)) }
  end
end
