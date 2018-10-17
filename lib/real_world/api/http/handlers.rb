# frozen_string_literal: true

require 'real_world/api/http/response'

module RealWorld
  module Api
    module Http
      module Handlers
        DEFAULT = ->(result, _env, status: 200) do
          result.delete(:events)
          result.update(payload: result.delete(:data))

          Response.call(status, result)
        end

        CREATED = ->(result, env) do
          DEFAULT.call(result, env, status: 201)
        end
      end
    end
  end
end
