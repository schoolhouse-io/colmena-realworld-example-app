# frozen_string_literal: true

require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/queries/are_articles_favorited'
require 'securerandom'

describe RealWorld::Article::Queries::AreArticlesFavorited do
  include_context 'article ports'
  include_context 'article factory'

  let(:query) { described_class.new(ports) }
  let(:user_id) { SecureRandom.uuid }
  subject { query.call(article_ids: [id], user_id: user_id) }

  before do
    repository.create(some_article)
    repository.favorite(some_article, user_id)
  end

  it { is_expected.to succeed(data: include(some_article.fetch(:id) => true)) }
end
