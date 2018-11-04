# frozen_string_literal: true

require 'colmena/query'
require 'real_world/api/queries/support'

module RealWorld
  module Api
    module Queries
      class ApiListArticles < Colmena::Query
        def call(auth_token: nil, author: nil, tag: nil, favorited: nil, limit: 100, offset: 0)
          auth_user_id = if auth_token
                           token, error = port(:tokens).decode_auth(auth_token)
                           return error_response(:unauthorized, reason: error) if error

                           token.fetch(:user_id)
                         end

          usernames = []
          usernames << author if author
          usernames << favorited if favorited

          users = port(:router).query(:index_users_by_username).call(
            usernames: usernames,
          ).fetch(:data)

          list_articles = port(:router).query(:list_articles).call(
            author_id: author && users[author]&.fetch(:id),
            tag: tag,
            favorited_by: favorited && users[favorited]&.fetch(:id),
            limit: limit,
            offset: offset,
          )

          capture_errors(list_articles) do
            articles = list_articles.fetch(:data)
            articles = Support.hydrate_articles(
              articles,
              router: port(:router),
              auth_token: auth_token,
              auth_user_id: auth_user_id,
            )

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
