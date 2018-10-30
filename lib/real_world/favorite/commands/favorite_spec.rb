# frozen_string_literal: true

require 'real_world/follow/ports/spec_shared_context'
require 'real_world/follow/spec_factory_shared_context'
require 'real_world/follow/commands/follow'

describe RealWorld::Follow::Commands::Follow do
  include_context 'follow ports'
  include_context 'follow factory'

  let(:command) { described_class.new(ports) }
  subject { command.call(follower_id: follower_id, followed_id: followed_id) }

  context 'when the user is already following the target' do
    before { repository.create(follower_id: follower_id, followed_id: followed_id) }
    it { is_expected.to fail_with_errors(:already_following) }
  end

  it {
    is_expected.to(
      succeed(
        data: include(
          follower_id: follower_id,
          followed_id: followed_id,
        ),
        events: [:user_was_followed],
      ),
    )
  }
end
