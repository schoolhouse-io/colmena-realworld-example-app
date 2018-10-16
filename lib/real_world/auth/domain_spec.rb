require 'real_world/auth/domain'

describe RealWorld::Auth::Domain do
  let(:email) { 'some@email.com' }
  let(:password) { 'some_password' }

  context 'when creating credentials' do
    context 'when all attributes are valid' do

      it 'creates credentials for the given user' do
        expect(described_class.create_credentials(email, password)).to(
          succeed(
            data: include(email: email, password: be_a(String), salt: be_a(String)),
            events: [:auth_credentials_created],
          )
        )
      end
    end

    context 'when the email is invalid' do
      it 'returns the errors' do
        emails = [
          nil,
          1,
          'a',
          '@',
          'a@',
        ]

        emails.each do |email|
          expect(described_class.create_credentials(email, password)).to(
            fail_with_errors(:email_is_invalid),
          )
        end
      end
    end

    context 'when the password is invalid' do
      it 'returns the errors' do
        passwords = [
          nil,
          '1',
          '123',
          '123456',
          'a' * 100,
        ]

        passwords.each do |password|
          expect(described_class.create_credentials(email, password)).to(
            fail_with_errors(:password_is_invalid),
          )
        end
      end
    end
  end
end
