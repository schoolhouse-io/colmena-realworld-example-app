# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiGetArticle < Colmena::Query
        def call(auth_token:, slug:)
          auth_user_id = if auth_token
                           token, error = port(:tokens).decode_auth(auth_token)
                           return error_response(:forbidden, reason: error) if error

                           token.fetch(:user_id)
                         end

          article = port(:router).query(:read_article_by_slug).call(
            slug: slug,
          ).fetch(:data)
          return error_response(:article_not_found, slug: slug) unless article

          author = port(:router).query(:read_user_by_id).call(
            id: article.fetch(:author_id),
          ).fetch(:data)

          is_favorited = if auth_user_id
                           port(:router).query(:are_articles_favorited).call(
                             article_ids: [article.fetch(:id)],
                             user_id: auth_user_id,
                           ).fetch(:data).fetch(article.fetch(:id))
                         else
                           false
                         end

          response(
            article: article.merge(
              author: port(:router).query(:api_get_profile).call(
                auth_token: auth_token,
                username: author.fetch(:username),
              ).fetch(:data),
              favorited: is_favorited,
            ),
          )
        end
      end
    end
  end
end
