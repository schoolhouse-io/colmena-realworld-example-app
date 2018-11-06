# frozen_string_literal: true

require 'colmena/cell'

module RealWorld
  module Tag
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_subscriber

      require 'real_world/tag/queries/list_tags'
      register_query Queries::ListTags

      require 'real_world/tag/listeners/counter'
      register_listener Listeners::Counter, event_stream: :article_events
    end
  end
end
