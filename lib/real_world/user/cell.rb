# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/user/materializer'
require 'real_world/user/commands/create_user'
require 'real_world/user/commands/update_user'
require 'real_world/user/queries/read_user_by_email'
require 'real_world/user/queries/read_user_by_id'

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

      register_command TRANSACTION[Commands::CreateUser]
      register_command TRANSACTION[Commands::UpdateUser]

      register_query Queries::ReadUserByEmail
      register_query Queries::ReadUserById
    end
  end
end
