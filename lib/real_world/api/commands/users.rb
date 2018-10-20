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
                response(user: user.merge(
                  token: port(:tokens).auth(user.fetch(:email), user.fetch(:id)),
                ))
              end
            end
          end
        end

        class ApiLogin < Colmena::Command
          def call(email:, password:)
            user = port(:router).query(:read_user_by_email).call(email: email).fetch(:data)
            return error_response(:invalid_crendentials) unless user

            valid_credentials = port(:router).query(:check_auth_credentials).call(
              user_id: user.fetch(:id),
              password: password,
            ).fetch(:data)
            return error_response(:invalid_crendentials) unless valid_credentials

            response(user: user.merge(
              token: port(:tokens).auth(user.fetch(:email), user.fetch(:id)),
            ))
          end
        end
      end
    end
  end
end
