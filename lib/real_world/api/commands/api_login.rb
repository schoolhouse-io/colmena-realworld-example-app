# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
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
