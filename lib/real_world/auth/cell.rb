# frozen_string_literal: true
require 'colmena/cell'
require 'real_world/auth/commands/create_auth_credentials'
require 'real_world/auth/queries/check_auth_credentials'

module RealWorld
  module Auth
    class Cell
      include Colmena::Cell

      register_port :repository
      register_command Commands::CreateAuthCredentials
      register_query Queries::CheckAuthCredentials
    end
  end
end
