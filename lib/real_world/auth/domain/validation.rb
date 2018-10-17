# frozen_string_literal: true

require 'uuid'
require 'dry-validation'
require 'colmena/domain/validation'

module RealWorld
  module Auth
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:user_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
          required(:password) { filled? & str? & size?(8..64) }
        }

        def self.user_id(user_id)
          field_errors(VALIDATOR, :user_id, user_id, :user_id_is_invalid)
        end

        def self.password(password)
          field_errors(VALIDATOR, :password, password, :password_is_invalid)
        end
      end
    end
  end
end
