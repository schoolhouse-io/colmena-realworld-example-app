# frozen_string_literal: true

module RealWorld
  module Http
    module Mappers
      class Retriever
        class URI
          ROUTER_PARAMS = 'router.params'

          def initialize(_request, env)
            @params = env.fetch(ROUTER_PARAMS)
          end

          def call(name)
            [@params[name], @params.key?(name), nil]
          end
        end
      end
    end
  end
end
