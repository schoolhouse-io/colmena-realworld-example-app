# frozen_string_literal: true

module RealWorld
  module Api
    module Queries
      module Support
        def self.hydrate_articles(articles, router:, auth_token: nil, auth_user_id: nil)
          article_ids = articles.map { |article| article.fetch(:id) }
          author_ids = articles.map { |article| article.fetch(:author_id) }

          profiles = router.query(:api_index_profiles).call(
            auth_token: auth_token,
            user_ids: author_ids,
          ).fetch(:data)

          is_favorited = if auth_user_id
                           router.query(:are_articles_favorited).call(
                             article_ids: article_ids,
                             user_id: auth_user_id,
                           ).fetch(:data)
                         else
                           {}
                         end

          articles.map do |article|
            article.merge(
              author: profiles.fetch(article.fetch(:author_id)),
              favorited: is_favorited[article.fetch(:id)] || false,
            )
          end
        end
      end
    end
  end
end
