# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Comment
    module Queries
      class ListComments < Colmena::Query
        def call(article_id:, limit: 100, offset: 0)
          comments, pagination_info = port(:repository).list(
            article_id: article_id,
            limit: limit,
            offset: offset,
          )

          response(comments, extras: { pagination: pagination_info })
        end
      end
    end
  end
end
