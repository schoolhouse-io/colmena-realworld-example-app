# frozen_string_literal: true

require 'colmena/listener'
require 'real_world/query'

module RealWorld
  module Feed
    module Listeners
      class Tracker < Colmena::Listener
        def call(event)
          case event.fetch(:type)
          when :article_created
            RealWorld::Query.iterate_paginated(
              ->(params) { port(:router).query(:list_followers).call(params) },
              followed_id: event.dig(:data, :author_id),
              limit: 1000,
            ) do |followers|
              followers.each do |follower_id|
                port(:repository).create(
                  user_id: follower_id,
                  article_id: event.dig(:data, :id),
                )
              end
            end
          end
        end
      end
    end
  end
end
