# frozen_string_literal: true
require 'colmena/cell'

module RealWorld
  module Auth
    class Cell
      include Colmena::Cell

      # Commands
      register_command Commands::CreateAuthCredentials
    end
  end
end
