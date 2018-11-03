# frozen_string_literal: true

require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/queries/read_article_by_slug'

describe RealWorld::Article::Queries::ReadArticleBySlug do
  include_context 'article ports'
  include_context 'article factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(slug: slug) }

  context 'when the article does not exist' do
    it { is_expected.to fail_with_errors(:article_does_not_exist) }
  end

  context 'when the article exists' do
    before { repository.create(some_article) }
    it { is_expected.to succeed(data: include(some_article)) }
  end
end
