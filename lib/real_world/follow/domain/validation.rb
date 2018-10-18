# frozen_string_literal: true

require 'dry-validation'
require 'colmena/domain/validation'
require 'real_world/uuid'

module RealWorld
  module Follow
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:user_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
        }

        def self.user_id(user_id)
          field_errors(VALIDATOR, :user_id, user_id, :user_id_is_invalid)
        end
      end
    end
  end
end
