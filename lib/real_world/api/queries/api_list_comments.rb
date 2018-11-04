# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiListComments < Colmena::Query
        def call(article_slug:, auth_token: nil, limit: 100, offset: 0)
          read_article = port(:router).query(:read_article_by_slug).call(
            slug: article_slug,
          )

          capture_errors(read_article) do
            article = read_article.fetch(:data)

            list_comments = port(:router).query(:list_comments).call(
              article_id: article.fetch(:id),
              limit: limit,
              offset: offset,
            )

            capture_errors(list_comments) do
              comments = list_comments.fetch(:data)
              author_ids = comments.map { |comment| comment.fetch(:author_id) }

              profiles = port(:router).query(:api_index_profiles).call(
                auth_token: auth_token,
                user_ids: author_ids,
              ).fetch(:data)

              comments = comments.map do |comment|
                comment.merge(
                  author: profiles.fetch(comment.fetch(:author_id)),
                )
              end

              response(
                comments: comments,
                extras: { pagination: list_comments.fetch(:pagination) },
              )
            end
          end
        end
      end
    end
  end
end
