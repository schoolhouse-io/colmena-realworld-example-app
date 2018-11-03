# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/user/materializer'

module RealWorld
  module User
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_publisher

      TRANSACTION = Colmena::Transactions::Materialize[
        event_materializer: Materializer,
        event_stream: :user_events,
      ]

      require 'real_world/user/queries/read_user_by_id'
      register_query Queries::ReadUserById

      require 'real_world/user/queries/read_user_by_email'
      register_query Queries::ReadUserByEmail

      require 'real_world/user/queries/read_user_by_username'
      register_query Queries::ReadUserByUsername

      require 'real_world/user/queries/index_users_by_username'
      register_query Queries::IndexUsersByUsername

      require 'real_world/user/commands/create_user'
      register_command TRANSACTION[Commands::CreateUser]

      require 'real_world/user/commands/update_user'
      register_command TRANSACTION[Commands::UpdateUser]
    end
  end
end
