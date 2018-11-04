# frozen_string_literal: true

require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/commands/favorite_article'
require 'securerandom'

describe RealWorld::Article::Commands::FavoriteArticle do
  include_context 'article ports'
  include_context 'article factory'

  let(:command) { described_class.new(ports) }
  let(:user_id) { SecureRandom.uuid }

  subject do
    command.call(
      id: id,
      user_id: user_id,
    )
  end

  context 'when the article does not exist' do
    it { is_expected.to fail_with_errors(:article_does_not_exist) }
  end

  context 'when the article exists' do
    before { repository.create(some_article) }

    context 'when the user has not favorited the article yet' do
      it {
        is_expected.to(
          succeed(
            data: include(favorites_count: 1),
            events: [:article_favorited],
          ),
        )
      }
    end

    context 'when the user has favorited the article already' do
      before { repository.favorite(some_article, user_id) }

      it { is_expected.to fail_with_errors(:article_already_favorited) }
    end
  end
end
