# frozen_string_literal: true

require 'colmena/cell'

module RealWorld
  module Feed
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_subscriber

      require 'real_world/feed/queries/list_articles_feed'
      register_query Queries::ListArticlesFeed

      require 'real_world/feed/listeners/tracker'
      register_listener Listeners::Tracker, event_stream: :article_events
    end
  end
end
