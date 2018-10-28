# frozen_string_literal: true

require 'real_world/tag/ports/spec_shared_context'
require 'real_world/tag/queries/list_tags'

describe RealWorld::Tag::Queries::ListTags do
  include_context 'tag ports'

  let(:limit) { 40 }
  let(:offset) { 2 }
  let(:query) { described_class.new(ports) }
  subject { query.call(limit: limit, offset: offset) }

  it 'returns the list from the repository and the pagination info' do
    expect(subject).to(
      include(
        data: be_an(Array),
        pagination: include(:limit, :offset, :total_elements),
      ),
    )
  end
end
