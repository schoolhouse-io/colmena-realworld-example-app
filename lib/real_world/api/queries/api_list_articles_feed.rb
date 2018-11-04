# frozen_string_literal: true

require 'colmena/query'
require 'real_world/api/queries/support'

module RealWorld
  module Api
    module Queries
      class ApiListArticlesFeed < Colmena::Query
        def call(auth_token:, limit: 100, offset: 0)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:unauthorized, reason: error) if error

          list_articles_feed = port(:router).query(:list_articles_feed).call(
            user_id: token.fetch(:user_id),
            limit: limit,
            offset: offset,
          )

          article_ids = list_articles_feed.fetch(:data)

          article_index = port(:router).query(:index_articles_by_id).call(
            ids: article_ids,
          ).fetch(:data)

          articles = article_ids.map { |article_id| article_index.dig(:data, article_id) }
          articles = Support.hydrate_articles(
            articles,
            router: port(:router),
            auth_token: auth_token,
            auth_user_id: token.fetch(:user_id),
          )

          response(
            articles: articles,
            extras: { pagination: list_articles_feed.fetch(:pagination) },
          )
        end
      end
    end
  end
end
