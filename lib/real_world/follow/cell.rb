# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/follow/materializer'

module RealWorld
  module Follow
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_publisher

      TRANSACTION = Colmena::Transactions::Materialize[
        event_materializer: Materializer,
        event_stream: :user_events,
      ]

      require 'real_world/follow/commands/follow'
      register_command TRANSACTION[Commands::Follow]

      require 'real_world/follow/commands/unfollow'
      register_command TRANSACTION[Commands::Unfollow]

      require 'real_world/follow/queries/is_followed'
      register_query Queries::IsFollowed

      require 'real_world/follow/queries/index_is_followed'
      register_query Queries::IndexIsFollowed

      require 'real_world/follow/queries/list_followed'
      register_query Queries::ListFollowed

      require 'real_world/follow/queries/list_followers'
      register_query Queries::ListFollowers
    end
  end
end
