# frozen_string_literal: true

require 'dry-validation'
require 'colmena/domain/validation'
require 'real_world/uuid'

module RealWorld
  module Comment
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:body) { filled? & str? }
          required(:author_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
          required(:article_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
        }

        def self.body(body)
          field_errors(VALIDATOR, :body, body, :body_is_invalid)
        end

        def self.author_id(author_id)
          field_errors(VALIDATOR, :author_id, author_id, :author_id_is_invalid)
        end

        def self.article_id(article_id)
          field_errors(VALIDATOR, :article_id, article_id, :article_id_is_invalid)
        end
      end
    end
  end
end
