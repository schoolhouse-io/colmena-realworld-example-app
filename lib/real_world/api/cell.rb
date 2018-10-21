# frozen_string_literal: true

require 'colmena/cell'
require 'real_world/api/commands/users'
require 'real_world/api/queries/users'
require 'real_world/api/http/routes'
require 'real_world/ports/http_router/hanami'

module RealWorld
  module Api
    class Cell
      include Colmena::Cell

      register_port :router
      register_port :tokens

      register_query Queries::Users::ApiGetCurrentUser

      register_command Commands::Users::ApiRegister
      register_command Commands::Users::ApiLogin
      register_command Commands::Users::ApiUpdateCurrentUser

      def call(env)
        @http_router ||= RealWorld::Ports::HttpRouter::Hanami.new(
          port(:router),
          Http::ROUTES,
        )

        @http_router.call(env)
      end
    end
  end
end
