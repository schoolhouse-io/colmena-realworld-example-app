# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      module Users
        class ApiRegister < Colmena::Command
          def call
            response(user: {})
          end
        end
      end
    end
  end
end
