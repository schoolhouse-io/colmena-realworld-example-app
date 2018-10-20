# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      module Users
        class ApiRegister < Colmena::Command
          def call(email:, password:, username:)
            create_user = port(:router).command(:create_user).call(
              email: email,
              username: username,
              bio: nil,
              image: nil,
            )

            capture_errors(create_user) do
              user = create_user.fetch(:data)

              create_credentials = port(:router).command(:create_auth_credentials).call(
                user_id: user.fetch(:id),
                password: password,
              )

              capture_errors(create_credentials) do
                response(user: user)
              end
            end
          end
        end
      end
    end
  end
end
