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

  before do
    expect(repository).to receive(:list)
      .with(parameters)
      .and_return([:result, :pagination])
  end

  it { is_expected.to include(data: eq(:result), pagination: eq(:pagination)) }
end
