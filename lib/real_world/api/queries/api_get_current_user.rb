# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiGetCurrentUser < Colmena::Query
        def call(auth_token:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:forbidden, reason: error) if error

          read_user = port(:router).query(:read_user_by_id).call(id: token.fetch(:user_id))
          capture_errors(read_user) do
            user = read_user.fetch(:data)
            response(user: user.merge(token: auth_token))
          end
        end
      end
    end
  end
end
