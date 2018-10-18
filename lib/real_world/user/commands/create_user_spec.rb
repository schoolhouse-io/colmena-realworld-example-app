# frozen_string_literal: true

require 'real_world/user/ports/spec_shared_context'
require 'real_world/user/spec_factory_shared_context'
require 'real_world/user/commands/create_user'

describe RealWorld::User::Commands::CreateUser do
  include_context 'user ports'
  include_context 'user factory'

  let(:command) { described_class.new(ports) }
  subject { command.call(email: email, username: username, bio: bio, image: image) }

  context 'when the email is in use' do
    before { repository.create(some_user.merge(username: 'different')) }
    it { is_expected.to fail_with_errors(:email_already_exists) }
  end

  context 'when the username is in use' do
    before { repository.create(some_user.merge(email: 'different@email.org')) }
    it { is_expected.to fail_with_errors(:username_already_exists) }
  end

  it {
    is_expected.to(
      succeed(
        data: include(
          id: be_a(String),
          email: email,
          username: username,
          bio: bio,
          image: image,
        ),
        events: [:user_created],
      ),
    )
  }
end
