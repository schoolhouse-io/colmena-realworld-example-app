# frozen_string_literal: true

require 'colmena/listener'
require 'real_world/query'

module RealWorld
  module Feed
    module Listeners
      class FollowerTracker < Colmena::Listener
        def call(event)
          case event.fetch(:type)
          when :user_was_followed
            follower_id = event.fetch(:data).fetch(:follower_id)

            RealWorld::Query.iterate_paginated(
              port(:router).query(:list_articles),
              author_id: event.fetch(:data).fetch(:followed_id),
              limit: 100,
            ) do |article|
              port(:repository).create(
                user_id: follower_id,
                article_id: article.fetch(:id),
                article_author_id: article.fetch(:author_id),
                article_created_at: article.fetch(:created_at),
              )
            end

          when :user_was_unfollowed
            port(:repository).delete_by_article_author(
              user_id: event.fetch(:data).fetch(:follower_id),
              article_author_id: event.fetch(:data).fetch(:followed_id),
            )

          end
        end
      end
    end
  end
end
