# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Follow
    module Queries
      class IndexIsFollowed < Colmena::Query
        def call(follower_id:, followed_ids:)
          is_followed_index = port(:repository).index_followed(
            by: follower_id,
            ids: followed_ids,
          )

          response(is_followed_index)
        end
      end
    end
  end
end
