# frozen_string_literal: true
require 'colmena/cell'
require 'real_world/auth/commands/create_auth_credentials'

module RealWorld
  module Auth
    class Cell
      include Colmena::Cell

      register_port :repository

      # Commands
      register_command Commands::CreateAuthCredentials
    end
  end
end
