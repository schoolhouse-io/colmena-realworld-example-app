# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Article
    module Queries
      class ListArticles < Colmena::Query
        def call(author_id: nil, tag: nil, favorited_by: nil, limit: 100, offset: 0)
          articles, pagination_info = port(:repository).list(
            author_id: author_id,
            tag: tag,
            favorited_by: favorited_by,
            limit: limit,
            offset: offset,
          )

          response(articles, extras: { pagination: pagination_info })
        end
      end
    end
  end
end
