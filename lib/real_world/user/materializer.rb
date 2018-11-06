# frozen_string_literal: true

require 'colmena/materializer'
require 'real_world/user/domain'

module RealWorld
  module User
    class Materializer < Colmena::Materializer
      def transaction
        port(:repository).transaction { yield }
      end

      def map(event)
        user = if event.fetch(:type) == :user_created
                 {}
               else
                 port(:repository).read_by_id(event.fetch(:data).fetch(:id))
               end

        Domain.apply(user, [event])
      end

      def call(event)
        return unless Domain.event?(event[:type])

        user = map(event)

        case event.fetch(:type)
        when :user_created then port(:repository).create(user)
        when :user_updated then port(:repository).update(user)
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
