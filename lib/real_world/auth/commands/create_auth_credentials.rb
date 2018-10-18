# frozen_string_literal: true

require 'colmena/command'
require 'real_world/auth/domain'

module RealWorld
  module Auth
    module Commands
      class CreateAuthCredentials < Colmena::Command
        def call(user_id:, password:)
          existing_credentials = port(:repository).read_by_user_id(user_id)
          return error_response(:credentials_already_exist) if existing_credentials

          Domain.create_credentials(user_id, password)
        end
      end
    end
  end
end
