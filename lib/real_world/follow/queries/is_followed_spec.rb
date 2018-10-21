# frozen_string_literal: true

require 'real_world/follow/spec_factory_shared_context'
require 'real_world/follow/ports/spec_shared_context'
require 'real_world/follow/queries/is_followed'

describe RealWorld::Follow::Queries::IsFollowed do
  include_context 'follow ports'
  include_context 'follow factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(follower_id: follower_id, followed_id: followed_id) }

  context 'when the user is not following the target' do
    it { is_expected.to succeed(data: be(false)) }
  end

  context 'when the user is following the target' do
    before { repository.create(follower_id: follower_id, followed_id: followed_id) }
    it { is_expected.to succeed(data: be(true)) }
  end
end
