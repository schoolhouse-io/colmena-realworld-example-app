require 'colmena/query'
require 'real_world/auth/domain'

module RealWorld
  module Auth
    module Queries
      class CheckAuthCredentials < Colmena::Query
        def call(email:, password:)
          credentials = port(:repository).read_by_email(email)

          if credentials && Domain.match?(credentials, password)
            response(true)
          else
            error_response(:credentials_do_not_match)
          end
        end
      end
    end
  end
end
