# frozen_string_literal: true

require 'colmena/command'
require 'real_world/follow/domain'

module RealWorld
  module Follow
    module Commands
      class Follow < Colmena::Command
        def call(follower_id:, followed_id:)
          if port(:repository).read(follower_id: follower_id, followed_id: followed_id)
            return error_response(:already_following)
          end

          Domain.follow(follower_id, followed_id)
        end
      end
    end
  end
end
