require 'real_world/auth/domain'

describe RealWorld::Auth::Domain do
  let(:email) { 'some@email.com' }
  let(:password) { 'some_password' }

  context 'when creating credentials' do
    subject { described_class.create_credentials(email, password) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(email: email, password: be_a(String), salt: be_a(String)),
            events: [:auth_credentials_created],
          )
        )
      }
    end

    [nil, 1, 'a', '@', 'a@'].each do |invalid_email|
      context "when the email is '#{invalid_email}'" do
        let(:email) { invalid_email }
        it { is_expected.to fail_with_errors(:email_is_invalid) }
      end
    end

    [nil, '1', '123', '123456', 'a' * 100].each do |invalid_password|
      context "when the password is '#{invalid_password}'" do
        let(:password) { invalid_password }
        it { is_expected.to fail_with_errors(:password_is_invalid) }
      end
    end

    context 'when checking credentials' do
      let(:credentials) { described_class.create_credentials(email, password).fetch(:data) }
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
end
