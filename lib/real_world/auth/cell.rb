# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/auth/materializer'
require 'real_world/auth/commands/create_auth_credentials'
require 'real_world/auth/queries/check_auth_credentials'

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

      register_command TRANSACTION[Commands::CreateAuthCredentials]

      register_query Queries::CheckAuthCredentials
    end
  end
end
