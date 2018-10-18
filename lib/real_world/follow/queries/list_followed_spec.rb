# frozen_string_literal: true

require 'real_world/follow/spec_factory_shared_context'
require 'real_world/follow/ports/spec_shared_context'
require 'real_world/follow/queries/list_followed'

describe RealWorld::Follow::Queries::ListFollowed do
  include_context 'follow ports'
  include_context 'follow factory'

  let(:limit) { 40 }
  let(:offset) { 2 }
  let(:query) { described_class.new(ports) }
  subject { query.call(follower_id: follower_id, limit: limit, offset: offset) }

  it 'returns the list from the repository and the pagination info' do
    expect(subject).to(
      include(
        data: be_an(Array),
        pagination: include(:limit, :offset, :total_elements),
      ),
    )
  end
end
