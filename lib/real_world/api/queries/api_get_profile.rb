# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiGetProfile < Colmena::Query
        def call(auth_token:, username:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:forbidden, reason: error) if error

          read_user = port(:router).query(:read_user_by_username).call(
            username: username,
          )

          capture_errors(read_user) do
            user = read_user.fetch(:data)

            is_following = port(:router).query(:is_followed).call(
              follower_id: token.fetch(:user_id),
              followed_id: user.fetch(:id),
            )

            capture_errors(is_following) do
              response(
                profile: Support.user_to_profile(
                  user,
                  following: is_following.fetch(:data),
                ),
              )
            end
          end
        end
      end
    end
  end
end
