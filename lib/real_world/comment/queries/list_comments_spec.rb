# frozen_string_literal: true

require 'real_world/comment/spec_factory_shared_context'
require 'real_world/comment/ports/spec_shared_context'
require 'real_world/comment/queries/list_comments'

describe RealWorld::Comment::Queries::ListComments do
  include_context 'comment ports'
  include_context 'comment factory'

  let(:limit) { 12 }
  let(:offset) { 25 }
  let(:query) { described_class.new(ports) }
  subject { query.call(article_id: article_id, limit: limit, offset: offset) }

  it 'returns an empty list and the pagination info' do
    expect(subject).to(
      include(
        data: be_empty,
        pagination: include(limit: limit, offset: offset, total_elements: 0),
      ),
    )
  end

  context 'when there are a few comments' do
    let(:offset) { 0 }

    let(:comments) do
      (1..4).map { some_comment.merge(id: SecureRandom.uuid) }
    end

    before do
      comments.each { |comment| repository.create(comment) }
    end

    it 'returns the list from the repository and the pagination info' do
      expect(subject).to(
        include(
          data: contain_exactly(*comments),
          pagination: include(limit: limit, offset: offset, total_elements: 4),
        ),
      )
    end
  end
end
