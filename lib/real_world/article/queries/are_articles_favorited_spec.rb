# frozen_string_literal: true

require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/queries/are_articles_favorited'

describe RealWorld::Article::Queries::AreArticlesFavorited do
  include_context 'article ports'
  include_context 'article factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(article_ids: [id], user_id: 'some-id') }

  before do
    expect(repository).to receive(:favorited?)
      .with(article_ids: [id], user_id: 'some-id')
      .and_return(:result)
  end

  it { is_expected.to succeed(data: eq(:result)) }
end
