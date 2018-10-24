# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/mappers/json'
require 'real_world/api/http/mappers/auth_token'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Users
          class Register
            include Endpoint
            command :api_register

            custom_mapper Mappers.combine(
              email: Mappers::Json.required(:user, :email),
              password: Mappers::Json.required(:user, :password),
              username: Mappers::Json.required(:user, :username),
            )
          end

          class Login
            include Endpoint
            command :api_login

            custom_mapper Mappers.combine(
              email: Mappers::Json.required(:user, :email),
              password: Mappers::Json.required(:user, :password),
            )
          end

          class GetCurrent
            include Endpoint
            query :api_get_current_user

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
            )
          end

          class UpdateCurrent
            include Endpoint
            command :api_update_current_user

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              email: Mappers::Json.optional(:user, :email),
              username: Mappers::Json.optional(:user, :username),
              bio: Mappers::Json.optional(:user, :bio),
              image: Mappers::Json.optional(:user, :image),
            )
          end
        end
      end
    end
  end
end
