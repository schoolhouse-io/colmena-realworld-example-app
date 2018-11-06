# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      class ApiUnfollowProfile < Colmena::Command
        def call(auth_token:, username:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:unauthorized, reason: error) if error

          read_user = port(:router).query(:read_user_by_username).call(
            username: username,
          )

          capture_errors(read_user) do
            user_to_unfollow = read_user.fetch(:data)

            port(:router).command(:unfollow).call(
              follower_id: token.fetch(:user_id),
              followed_id: user_to_unfollow.fetch(:id),
            )

            response(user_to_unfollow.merge(following: false))
          end
        end
      end
    end
  end
end
