# frozen_string_literal: true

require 'dry-validation'
require 'colmena/domain/validation'
require 'real_world/uuid'

module RealWorld
  module Favorite
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:article_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
          required(:user_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
        }

        def self.article_id(article_id)
          field_errors(VALIDATOR, :article_id, article_id, :article_id_is_invalid)
        end

        def self.user_id(user_id)
          field_errors(VALIDATOR, :user_id, user_id, :user_id_is_invalid)
        end
      end
    end
  end
end
