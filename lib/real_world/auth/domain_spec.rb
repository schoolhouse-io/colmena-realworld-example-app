require 'real_world/auth/domain'

describe RealWorld::Auth::Domain do
  let(:email) { 'some@email.com' }
  let(:password) { 'some_password' }

  context 'when creating credentials' do
    context 'when all attributes are valid' do

      it 'creates credentials for the given user' do
        expect(described_class.create_credentials(email, password)).to(
          include(
            data: include(password: be_a(String), salt: be_a(String)),
          )
        )
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
          resp = described_class.create_credentials(email, password)
          expect(resp.fetch(:errors)).not_to(
            be_empty, "Expected credentials with wrong #{password} to return errors",
          )
        end
      end
    end
  end
end
