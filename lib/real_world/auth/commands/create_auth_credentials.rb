require 'colmena/command'
require 'real_world/auth/domain'

module RealWorld
  module Auth
    module Commands
      class CreateAuthCredentials < Colmena::Command
        def call(email:, password:)
          existing_credentials = port(:repository).read_by_email(email)
          return error_response(:credentials_already_exist) if existing_credentials

          Domain.create_credentials(email, password)
        end
      end
    end
  end
end
