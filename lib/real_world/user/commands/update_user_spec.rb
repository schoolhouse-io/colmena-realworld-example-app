# frozen_string_literal: true

require 'real_world/user/ports/spec_shared_context'
require 'real_world/user/spec_factory_shared_context'
require 'real_world/user/commands/update_user'

describe RealWorld::User::Commands::UpdateUser do
  include_context 'user ports'
  include_context 'user factory'

  let(:new_email) { 'new@email.org' }
  let(:new_username) { 'new_username' }
  let(:new_bio) { 'new_bio' }
  let(:new_image) { 'http://new-image.com' }

  let(:command) { described_class.new(ports) }
  subject do
    command.call(
      id: id,
      email: new_email,
      username: new_username,
      bio: new_bio,
      image: new_image
    )
  end

  context 'when the user does not exist' do
    it { is_expected.to fail_with_errors(:user_does_not_exist) }
  end

  context 'when the user exists' do
    before { repository.create(some_user) }

    context 'when the email is in use' do
      before do
        repository.create(
          some_user.merge(
            id: SecureRandom.uuid,
            email: new_email,
            username: 'unrelated',
          )
        )
      end

      it { is_expected.to fail_with_errors(:email_already_exists) }
    end

    context 'when the username is in use' do
      before do
        repository.create(
          some_user.merge(
            id: SecureRandom.uuid,
            email: 'unrelated@email.org',
            username: new_username,
          )
        )
      end

      it { is_expected.to fail_with_errors(:username_already_exists) }
    end

    it {
      is_expected.to(
        succeed(
          data: include(
            id: id,
            email: new_email,
            username: new_username,
            bio: new_bio,
            image: new_image,
          ),
          events: [:user_updated],
        ),
      )
    }
  end
end
