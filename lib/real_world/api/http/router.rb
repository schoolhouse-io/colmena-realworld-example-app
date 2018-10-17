# frozen_string_literal: true

require 'colmena/command'
require 'real_world/ports/http_router/hanami'

module RealWorld
  module API
    module HTTP
      module Router
        ROUTES = ->(*) do
        end

        class ApiHandleRequest < Colmena::Command
          def call(env:)
            @http_router ||= RealWorld::Ports::HTTPRouter::Hanami.new(
              port(:router),
              ROUTES,
            )

            @http_router.call(env)
          end
        end
      end
    end
  end
end
