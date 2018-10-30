# frozen_string_literal: true

require 'colmena/materializer'
require 'real_world/favorite/domain'

module RealWorld
  module Favorite
    class Materializer < Colmena::Materializer
      def transaction
        port(:repository).transaction { yield }
      end

      def call(event)
        return unless Domain.event?(event[:type])

        favorite = event.fetch(:data).slice(:article_id, :user_id)

        case event.fetch(:type)
        when :article_favorited
          port(:repository).create(favorite)

        when :article_unfavorited
          port(:repository).delete(favorite)

        end
        # TODO: Log unhandled event
      end
    end
  end
end
