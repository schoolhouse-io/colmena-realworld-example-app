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
        when :article_updated, :article_tag_added, :article_tag_deleted
          port(:repository).update(article)
        when :article_favorited
          port(:repository).favorite(article, event.fetch(:data).fetch(:user_id))
        when :article_unfavorited
          port(:repository).unfavorite(article, event.fetch(:data).fetch(:user_id))
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
