# frozen_string_literal: true

require 'colmena/listener'
require 'real_world/query'

module RealWorld
  module Feed
    module Listeners
      class ArticleTracker < Colmena::Listener
        def call(event)
          case event.fetch(:type)
          when :article_created
            RealWorld::Query.iterate_paginated(
              port(:router).query(:list_followers),
              followed_id: event.dig(:data, :author_id),
              limit: 1000,
            ) do |follower_id|
              port(:repository).create(
                user_id: follower_id,
                article_id: event.dig(:data, :id),
                article_author_id: event.dig(:data, :author_id),
                article_created_at: event.dig(:data, :created_at),
              )
            end
          end
        end
      end
    end
  end
end
