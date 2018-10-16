# frozen_string_literal: true

require 'email'
require 'colmena/domain/validation'

module RealWorld
  module Auth
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:email) { filled? & str? & format?(Email::VALIDATION_REGEX) }
          required(:password) { filled? & str? & size?(8..64) }
        }

        def self.email(email)
          field_errors(VALIDATOR, :email, email, :email_is_invalid)
        end

        def self.password(password)
          field_errors(VALIDATOR, :password, password, :password_is_invalid)
        end
      end
    end
  end
end
