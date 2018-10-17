# frozen_string_literal: true

require 'colmena/cell'
require 'real_world/api/commands/users'
require 'real_world/api/http/router'

module RealWorld
  module API
    class Cell
      include Colmena::Cell

      register_port :router

      register_command HTTP::Router::ApiHandleRequest
      register_command Commands::Users::ApiRegister
    end
  end
end
