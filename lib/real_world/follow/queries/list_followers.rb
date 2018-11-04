# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Follow
    module Queries
      class ListFollowers < Colmena::Query
        def call(followed_id:, limit: 100, offset: 0)
          followers, pagination_info = port(:repository).list_followers(
            of: followed_id,
            limit: limit,
            offset: offset,
          )

          response(followers, extras: { pagination: pagination_info })
        end
      end
    end
  end
end
