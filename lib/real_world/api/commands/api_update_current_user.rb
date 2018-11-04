# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      class ApiUpdateCurrentUser < Colmena::Command
        def call(auth_token:, email: nil, username: nil, bio: nil, image: nil)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:unauthorized, reason: error) if error

          updated_user = port(:router).command(:update_user).call(
            id: token.fetch(:user_id),
            email: email,
            username: username,
            bio: bio,
            image: image,
          )

          capture_errors(updated_user) do
            user = updated_user.fetch(:data)
            response(user: user.merge(token: auth_token))
          end
        end
      end
    end
  end
end
