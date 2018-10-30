# frozen_string_literal: true

require 'securerandom'
require 'colmena/domain'
require 'real_world/favorite/domain/validation'

module RealWorld
  module Favorite
    module Domain
      extend Colmena::Domain

      events :article_favorited,
             handler: ->(_, event) { event.fetch(:data) }

      events :article_unfavorited,
             handler: ->(*) { nil }

      def self.favorite(article_id, user_id)
        capture_errors(
          Validation.article_id(article_id),
          Validation.user_id(user_id),
        ) do
          favorite = { article_id: article_id, user_id: user_id }

          response(
            favorite,
            events: [event(:article_favorited, favorite)],
          )
        end
      end

      def self.unfavorite(favorite)
        return error_response(:not_favorited) unless favorite

        response(nil, events: [event(:article_unfavorited, relationship)])
      end
    end
  end
end
