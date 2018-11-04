# frozen_string_literal: true

require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/queries/list_articles'

describe RealWorld::Article::Queries::ListArticles do
  include_context 'article ports'
  include_context 'article factory'

  let(:query) { described_class.new(ports) }
  let(:parameters) do
    {
      author_id: 'some-id',
      tag: 'some-tag',
      favorited_by: 'another-id',
      limit: 123,
      offset: 123,
    }
  end

  subject do
    query.call(parameters)
  end

  it 'returns the list from the repository and the pagination info' do
    expect(subject).to(
      include(
        data: be_an(Array),
        pagination: include(:limit, :offset, :total_elements),
      ),
    )
  end
end
