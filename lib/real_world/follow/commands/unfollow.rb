# frozen_string_literal: true

require 'colmena/command'
require 'real_world/follow/domain'

module RealWorld
  module Follow
    module Commands
      class Unfollow < Colmena::Command
        def call(follower_id:, followed_id:)
          Domain.unfollow(
            port(:repository).read(
              follower_id: follower_id,
              followed_id: followed_id,
            ),
          )
        end
      end
    end
  end
end
