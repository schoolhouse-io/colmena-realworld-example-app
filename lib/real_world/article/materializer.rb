# frozen_string_literal: true

require 'colmena/materializer'
require 'real_world/article/domain'

module RealWorld
  module Article
    class Materializer < Colmena::Materializer
      def transaction
        port(:repository).transaction { yield }
      end

      def map(event)
        article = if event.fetch(:type) == :article_created
                    {}
                  else
                    port(:repository).read_by_id(event.fetch(:data).fetch(:id))
                  end

        Domain.apply(article, [event])
      end

      def call(event)
        return unless Domain.event?(event[:type])

        article = map(event)

        case event.fetch(:type)
        when :article_created then port(:repository).create(article)
        end
        # TODO: Log unhandled event
      end
    end
  end
end
