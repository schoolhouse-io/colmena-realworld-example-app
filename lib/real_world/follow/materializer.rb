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

        else
          port(:logger).warn {
            "#{self.class.name} is not handling events of type #{event.fetch(:type)}." \
            'This is most likely a mistake.'
          }
        end
      end
    end
  end
end
