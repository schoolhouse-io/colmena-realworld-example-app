# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/user/materializer'
require 'real_world/user/commands/create_user'
require 'real_world/user/commands/update_user'
require 'real_world/user/queries/read_user_by_email'

module RealWorld
  module User
    class Cell
      include Colmena::Cell

      register_port :repository

      TRANSACTION = Colmena::Transactions::Materialize[
        materializer: Materializer,
        topic: :user_events,
      ]

      register_command TRANSACTION[Commands::CreateUser]
      register_command TRANSACTION[Commands::UpdateUser]

      register_query Queries::ReadUserByEmail
    end
  end
end
