# frozen_string_literal: true

require 'real_world/follow/domain'
require 'real_world/follow/spec_factory_shared_context'

describe RealWorld::Follow::Domain do
  include_context 'follow factory'

  describe '.follow' do
    subject { described_class.follow(follower_id, followed_id) }

    context 'when all attributes are valid' do
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

    [nil, 1, 'a'].each do |invalid_id|
      context "when the follower_id is '#{invalid_id}'" do
        let(:follower_id) { invalid_id }
        it { is_expected.to fail_with_errors(:user_id_is_invalid) }
      end

      context "when the followed_id is '#{invalid_id}'" do
        let(:followed_id) { invalid_id }
        it { is_expected.to fail_with_errors(:user_id_is_invalid) }
      end
    end
  end

  describe '.unfollow' do
    subject { described_class.unfollow(relationship) }

    context 'when the user is following the target' do
      let(:relationship) do
        {
          follower_id: follower_id,
          followed_id: followed_id,
        }
      end

      it {
        is_expected.to(
          succeed(
            data: be(nil),
            events: [:user_was_unfollowed],
          ),
        )
      }
    end

    context 'when the user is not following the target' do
      let(:relationship) { nil }
      it { is_expected.to fail_with_errors(:not_following) }
    end
  end
end
