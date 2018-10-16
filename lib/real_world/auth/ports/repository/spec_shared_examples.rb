RSpec.shared_examples 'an auth repository' do
  before { subject.clear }

  let(:credentials) do
    {email: 'some@email.com', password: 'password_hash', salt: 'random' }
  end

  context 'when there are no credentials stored' do
    it '#create' do
      expect { subject.create(credentials) }.not_to raise_error
    end

    it '#read_by_user' do
      expect(subject.read_by_email(credentials.fetch(:email))).to be(nil)
    end
  end

  context 'when a user has some credentials' do
    before { subject.create(credentials) }

    it '#create credentials for the same email' do
      new_credentials = credentials.merge(password: rand(100))
      expect { subject.create(new_credentials) }.to raise_error(StandardError)
    end

    it '#read_by_email' do
      expect(subject.read_by_email(credentials.fetch(:email))).to include(credentials)
    end

    it '#delete' do
      expect(subject.delete(credentials.fetch(:email))).to eq(1)
      expect(subject.read_by_email(credentials.fetch(:email))).to be(nil)
    end
  end
end
