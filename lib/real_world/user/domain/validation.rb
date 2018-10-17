# frozen_string_literal: true

require 'uri'
require 'email'
require 'dry-validation'
require 'colmena/domain/validation'

module RealWorld
  module User
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:email) { filled? & str? & format?(Email::VALIDATION_REGEX) }
          required(:username) { filled? & str? & size?(4..30) & format?(/^[a-z0-9_]+$/) }
          required(:bio) { empty? | str? & max_size?(200) }
          required(:image) { empty? | str? & max_size?(200) & format?(/^#{URI::regexp(['http', 'https'])}$/) }
        }

        def self.email(email)
          field_errors(VALIDATOR, :email, email, :email_is_invalid)
        end

        def self.username(username)
          field_errors(VALIDATOR, :username, username, :username_is_invalid)
        end

        def self.bio(bio)
          field_errors(VALIDATOR, :bio, bio, :bio_is_invalid)
        end

        def self.image(image)
          field_errors(VALIDATOR, :image, image, :image_is_invalid)
        end
      end
    end
  end
end
