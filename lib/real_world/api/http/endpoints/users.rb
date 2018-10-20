# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Users
          class Register
            include Endpoint
            command :api_register

            custom_mapper Mappers.combine(
              email: Mappers::Json.at(:user, :email),
              password: Mappers::Json.at(:user, :password),
              username: Mappers::Json.at(:user, :username),
            )
          end

          class Login
            include Endpoint
            command :api_login

            custom_mapper Mappers.combine(
              email: Mappers::Json.at(:user, :email),
              password: Mappers::Json.at(:user, :password),
            )
          end
        end
      end
    end
  end
end
