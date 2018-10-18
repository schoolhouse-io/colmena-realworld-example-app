# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Follow
    module Queries
      class ListFollowed < Colmena::Query
        def call(follower_id:, limit: 100, offset: 0)
          followed, pagination_info = port(:repository).list_followed(
            by: follower_id,
            limit: limit,
            offset: offset,
          )

          response(followed, extras: {pagination: pagination_info})
        end
      end
    end
  end
end
