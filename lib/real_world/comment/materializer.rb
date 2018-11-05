# frozen_string_literal: true

require 'colmena/materializer'
require 'real_world/comment/domain'

module RealWorld
  module Comment
    class Materializer < Colmena::Materializer
      def transaction
        port(:repository).transaction { yield }
      end

      def map(event)
        comment = if event.fetch(:type) == :comment_created
                    {}
                  else
                    port(:repository).read_by_id(event.fetch(:data).fetch(:id))
                  end

        Domain.apply(comment, [event])
      end

      def call(event)
        return unless Domain.event?(event[:type])

        comment = map(event)

        case event.fetch(:type)
        when :comment_created then port(:repository).create(comment)
        when :comment_deleted then port(:repository).delete(comment)
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
