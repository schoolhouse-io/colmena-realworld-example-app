# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiGetProfile < Colmena::Query
        def call(auth_token:, username:)
          auth_user_id = if auth_token
                           token, error = port(:tokens).decode_auth(auth_token)
                           return error_response(:unauthorized, reason: error) if error

                           token.fetch(:user_id)
                         end

          read_user = port(:router).query(:read_user_by_username).call(
            username: username,
          )

          capture_errors(read_user) do
            user = read_user.fetch(:data)

            is_following = if auth_user_id
                             port(:router).query(:is_followed).call(
                               follower_id: auth_user_id,
                               followed_id: user.fetch(:id),
                             ).fetch(:data)
                           else
                             false
                           end

            response(
              profile: Support.user_to_profile(
                user,
                following: is_following,
              ),
            )
          end
        end
      end
    end
  end
end
