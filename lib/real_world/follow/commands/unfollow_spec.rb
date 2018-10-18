# frozen_string_literal: true

require 'real_world/follow/ports/spec_shared_context'
require 'real_world/follow/spec_factory_shared_context'
require 'real_world/follow/commands/unfollow'

describe RealWorld::Follow::Commands::Unfollow do
  include_context 'follow ports'
  include_context 'follow factory'

  let(:command) { described_class.new(ports) }
  subject { command.call(follower_id: follower_id, followed_id: followed_id) }

  context 'when the user is not following the target' do
    it { is_expected.to fail_with_errors(:not_following) }
  end

  context 'when the user is following the target' do
    before { repository.create(follower_id: follower_id, followed_id: followed_id) }

    it {
      is_expected.to(
        succeed(
          data: be(nil),
          events: [:user_was_unfollowed],
        ),
      )
    }
  end
end
