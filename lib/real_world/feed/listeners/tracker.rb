# frozen_string_literal: true

require 'colmena/listener'

module RealWorld
  module Feed
    module Listeners
      class Tracker < Colmena::Listener
        def call(event)
          case event.fetch(:type)
          when :article_created
            followers = port(:router).query(:list_followers).call(
              followed_id: event.dig(:data, :author_id),
            ).fetch(:data)

            followers.each do |follower_id|
              port(:repository).create(
                user_id: follower_id,
                article_id: event.dig(:data, :id),
              )
            end
          end
          # TODO: Log unhandled event
        end
      end
    end
  end
end
