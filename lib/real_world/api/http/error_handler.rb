# frozen_string_literal: true

require 'real_world/api/http/response'

module RealWorld
  module Api
    module Http
      module ErrorHandler
        def self.call(errors)
          error = errors.first

          Response.call(
            status_code(error),
            payload: nil,
            error: error,
          )
        end

        def self.status_code(_error)
          400
        end
      end
    end
  end
end
