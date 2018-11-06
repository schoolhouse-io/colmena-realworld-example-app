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
          MAP = ->(profile) do
            {
              username: profile.fetch(:username),
              bio: profile.fetch(:bio),
              image: profile.fetch(:image),
              following: profile.fetch(:following),
            }
          end

          RETURN_ONE = ->(result, _env) do
            data = result.fetch(:data)

            Response.call(
              200,
              data.merge(profile: MAP.call(data)),
            )
          end

          class Get
            include Endpoint
            query :api_get_profile

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              username: Mappers::Route.segment(:username),
            )

            custom_handler RETURN_ONE
          end

          class Follow
            include Endpoint
            command :api_follow_profile

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              username: Mappers::Route.segment(:username),
            )

            custom_handler RETURN_ONE
          end

          class Unfollow
            include Endpoint
            command :api_unfollow_profile

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              username: Mappers::Route.segment(:username),
            )

            custom_handler RETURN_ONE
          end
        end
      end
    end
  end
end
