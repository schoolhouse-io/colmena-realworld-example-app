require 'colmena/command'
require 'real_world/auth/domain'

module RealWorld
  module Auth
    module Commands
      class CreateAuthCredentials < Colmena::Command
        def call(email:, password:)
          new_record = port(:credentials_repository).read_by_email(email).nil?

          credentials, events, errors = Domain.create(email, password)
          response(credentials, events, errors)
        end
      end
    end
  end
end
