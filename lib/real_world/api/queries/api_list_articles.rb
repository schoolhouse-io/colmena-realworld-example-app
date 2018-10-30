# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiListArticles < Colmena::Query
        def call(auth_token: nil, limit: 100, offset: 0)
          auth_user_id = if auth_token
                           token, error = port(:tokens).decode_auth(auth_token)
                           return error_response(:forbidden, reason: error) if error

                           token.fetch(:user_id)
                         end

          list_articles = port(:router).query(:list_articles).call(
            limit: limit,
            offset: offset,
          )

          capture_errors(list_articles) do
            articles = list_articles.fetch(:data)
            article_ids = articles.map { |article| article.fetch(:id) }
            author_ids = articles.map { |article| article.fetch(:author_id) }

            profiles = port(:router).query(:api_index_profiles).call(
              auth_token: auth_token,
              user_ids: author_ids,
            ).fetch(:data)

            is_favorited = if auth_user_id
                             port(:router).query(:is_favorited).call(
                               article_ids: article_ids,
                               user_id: auth_user_id,
                             ).fetch(:data)
                           else
                             {}
                           end

            favorites_count = port(:router).query(:count_favorites).call(
              article_ids: article_ids,
            ).fetch(:data)

            articles = articles.map do |article|
              article.merge(
                author: profiles.fetch(article.fetch(:author_id)),
                favorited: is_favorited[article.fetch(:id)] || false,
                favorites_count: favorites_count.fetch(article.fetch(:id)),
              )
            end

            response(
              articles: articles,
              extras: { pagination: list_articles.fetch(:pagination) },
            )
          end
        end
      end
    end
  end
end
