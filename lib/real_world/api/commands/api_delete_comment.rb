# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      class ApiDeleteComment < Colmena::Command
        def call(auth_token:, id:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:unauthorized, reason: error) if error

          read_comment = port(:router).query(:read_comment_by_id).call(
            id: id,
          )

          capture_errors(read_comment) do
            comment = read_comment.fetch(:data)

            return error_response(:forbidden) unless comment.fetch(:author_id) == token.fetch(:user_id)

            delete_comment = port(:router).command(:delete_comment).call(
              id: id,
            )

            capture_errors(delete_comment) do
              response(true)
            end
          end
        end
      end
    end
  end
end
