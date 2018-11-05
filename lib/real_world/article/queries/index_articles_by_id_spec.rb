# frozen_string_literal: true

require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/queries/index_articles_by_id'
require 'securerandom'

describe RealWorld::Article::Queries::IndexArticlesById do
  include_context 'article ports'
  include_context 'article factory'

  let(:query) { described_class.new(ports) }
  let(:parameters) do
    {
      ids: [SecureRandom.uuid],
    }
  end

  subject do
    query.call(parameters)
  end

  it 'returns the index from the repository' do
    expect(subject).to(
      include(
        data: be_a(Hash),
      ),
    )
  end
end
