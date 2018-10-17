# frozen_string_literal: true

require 'securerandom'
require 'real_world/user/spec_factory_shared_context'

RSpec.shared_examples 'a user repository' do
  include_context 'user factory'

  before { subject.clear }

  context 'when there are no users stored' do
    it '#create' do
      expect {subject.create(some_user)}.not_to raise_error
    end

    it '#read_by_id' do
      expect(subject.read_by_id(id)).to be(nil)
    end

    it '#read_by_email' do
      expect(subject.read_by_email(email)).to be(nil)
    end

    it '#read_by_username' do
      expect(subject.read_by_username(username)).to be(nil)
    end
  end

  context 'when there is a user' do
    before { subject.create(some_user) }

    let(:different_id) { SecureRandom.uuid }
    let(:different_email) { 'different@email.org' }
    let(:different_username) { 'different_email' }

    describe '#create' do
      context 'when the id is duplicated' do
        it 'raises an exception' do
          expect {
            subject.create(some_user.merge(email: different_email, username: different_username))
          }.to raise_error(StandardError)
        end
      end

      context 'when the email is duplicated' do
        it 'raises an exception' do
          expect {
            subject.create(some_user.merge(id: different_id, username: different_username))
          }.to raise_error(StandardError)
        end
      end

      context 'when the username is duplicated' do
        it 'raises an exception' do
          expect {
            subject.create(some_user.merge(id: different_id, email: different_email))
          }.to raise_error(StandardError)
        end
      end
    end

    describe '#update' do
      let(:new_bio) { 'This is my flaming new bio'}
      let(:new_image) { 'https://new.image.org'}

      it 'updates all fields' do
        subject.update(
          id: id,
          email: different_email,
          username: different_username,
          bio: new_bio,
          image: new_image,
        )

        expect(subject.read_by_id(id)).to(
          include(
            email: different_email,
            username: different_username,
            bio: new_bio,
            image: new_image,
          )
        )
      end
    end

    it '#read_by_id' do
      expect(subject.read_by_id(id)).to include(:id, :email, :username, :bio, :image)
    end

    it '#read_by_email' do
      expect(subject.read_by_email(email)).to include(:id, :email, :username, :bio, :image)
    end

    it '#read_by_username' do
      expect(subject.read_by_username(username)).to include(:id, :email, :username, :bio, :image)
    end
  end
end
