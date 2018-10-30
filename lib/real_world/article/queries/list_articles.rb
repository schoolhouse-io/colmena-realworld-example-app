# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Article
    module Queries
      class ListArticles < Colmena::Query
        def call(limit: 100, offset: 0)
          articles, pagination_info = port(:repository).list(
            limit: limit,
            offset: offset,
          )

          response(articles, extras: { pagination: pagination_info })
        end
      end
    end
  end
end
