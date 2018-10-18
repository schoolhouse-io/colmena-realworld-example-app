# frozen_string_literal: true

require 'securerandom'
require 'colmena/domain'
require 'real_world/follow/domain/validation'

module RealWorld
  module Follow
    module Domain
      extend Colmena::Domain

      events :user_was_followed,
             handler: ->(_, event) { event.fetch(:data) }

      events :user_was_unfollowed,
             handler: ->(*) { nil }

      def self.follow(follower_id, followed_id)
        capture_errors(
          Validation.user_id(follower_id),
          Validation.user_id(followed_id),
        ) do
          relationship = { follower_id: follower_id, followed_id: followed_id }

          response(
            relationship,
            events: [event(:user_was_followed, relationship)],
          )
        end
      end

      def self.unfollow(relationship)
        return error_response(:not_following) unless relationship

        response(nil, events: [event(:user_was_unfollowed, relationship)])
      end
    end
  end
end
