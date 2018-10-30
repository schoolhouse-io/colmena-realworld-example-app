# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/favorite/materializer'

module RealWorld
  module Favorite
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_publisher

      TRANSACTION = Colmena::Transactions::Materialize[
        event_materializer: Materializer,
        event_stream: :article_events,
      ]

      require 'real_world/favorite/commands/favorite'
      register_command TRANSACTION[Commands::Favorite]

      require 'real_world/favorite/commands/unfavorite'
      register_command TRANSACTION[Commands::Unfavorite]

      require 'real_world/favorite/queries/is_favorited'
      register_query Queries::IsFavorited

      require 'real_world/favorite/queries/count_favorites'
      register_query Queries::CountFavorites
    end
  end
end
