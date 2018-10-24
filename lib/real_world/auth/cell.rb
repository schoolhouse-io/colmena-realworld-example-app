# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/auth/materializer'

module RealWorld
  module Auth
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_publisher

      TRANSACTION = Colmena::Transactions::Materialize[
        event_materializer: Materializer,
        event_stream: :auth_events,
      ]

      require 'real_world/auth/queries/check_auth_credentials'
      register_query Queries::CheckAuthCredentials

      require 'real_world/auth/commands/create_auth_credentials'
      register_command TRANSACTION[Commands::CreateAuthCredentials]
    end
  end
end
