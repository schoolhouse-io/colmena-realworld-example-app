# frozen_string_literal: true

require 'colmena/command'
require 'real_world/api/queries/support'

module RealWorld
  module Api
    module Commands
      class ApiFollowProfile < Colmena::Command
        def call(auth_token:, username:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:unauthorized, reason: error) if error

          read_user = port(:router).query(:read_user_by_username).call(
            username: username,
          )

          capture_errors(read_user) do
            user_to_follow = read_user.fetch(:data)

            port(:router).command(:follow).call(
              follower_id: token.fetch(:user_id),
              followed_id: user_to_follow.fetch(:id),
            )

            response(
              profile: Queries::Support.user_to_profile(
                user_to_follow,
                following: true,
              ),
            )
          end
        end
      end
    end
  end
end
