# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Feed
    module Queries
      class ListArticlesFeed < Colmena::Query
        def call(user_id:, limit: 100, offset: 0)
          article_ids, pagination_info = port(:repository).list(
            user_id: user_id,
            limit: limit,
            offset: offset,
          )

          response(article_ids, extras: { pagination: pagination_info })
        end
      end
    end
  end
end
