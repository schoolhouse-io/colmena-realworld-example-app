# frozen_string_literal: true

require 'colmena/materializer'
require 'real_world/follow/domain'

module RealWorld
  module Follow
    class Materializer < Colmena::Materializer
      def transaction
        port(:repository).transaction { yield }
      end

      def call(event)
        return unless Domain.event?(event[:type])

        relationship = event.fetch(:data).slice(:follower_id, :followed_id)

        case event.fetch(:type)
        when :user_was_followed
          port(:repository).create(relationship)

        when :user_was_unfollowed
          port(:repository).delete(relationship)

        end
        # TODO: Log unhandled event
      end
    end
  end
end
