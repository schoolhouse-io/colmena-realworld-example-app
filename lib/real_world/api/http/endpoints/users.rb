# frozen_string_literal: true

require 'real_world/api/http/endpoint'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Users
          class Register
            include Endpoint
            command :api_register
          end
        end
      end
    end
  end
end
