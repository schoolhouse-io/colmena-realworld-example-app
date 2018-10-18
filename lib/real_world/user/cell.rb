# frozen_string_literal: true

require 'colmena/cell'
require 'real_world/user/commands/create_user'
require 'real_world/user/commands/update_user'
require 'real_world/user/queries/read_user_by_email'

module RealWorld
  module User
    class Cell
      include Colmena::Cell

      register_port :repository
      register_command Commands::CreateUser
      register_command Commands::UpdateUser
      register_query Queries::ReadUserByEmail
    end
  end
end
