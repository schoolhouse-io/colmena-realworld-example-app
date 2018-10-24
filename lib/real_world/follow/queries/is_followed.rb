# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Follow
    module Queries
      class IsFollowed < Colmena::Query
        def call(follower_id:, followed_id:)
          response(
            !port(:repository).read(follower_id: follower_id, followed_id: followed_id).nil?,
          )
        end
      end
    end
  end
end
