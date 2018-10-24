# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/mappers/route'
require 'real_world/api/http/mappers/auth_token'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Profiles
          class Get
            include Endpoint
            query :api_get_profile

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              username: Mappers::Route.segment(:username),
            )
          end

          class Follow
            include Endpoint
            command :api_follow_profile

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              username: Mappers::Route.segment(:username),
            )
          end

          class Unfollow
            include Endpoint
            command :api_unfollow_profile

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              username: Mappers::Route.segment(:username),
            )
          end
        end
      end
    end
  end
end
