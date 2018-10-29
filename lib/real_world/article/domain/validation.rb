# frozen_string_literal: true

require 'uri'
require 'dry-validation'
require 'colmena/domain/validation'
require 'real_world/uuid'

module RealWorld
  module Article
    module Domain
      module Validation
        extend Colmena::Domain::Validation

        VALIDATOR = Dry::Validation.Schema {
          required(:title) { filled? & str? & min_size?(5) & max_size?(100) }
          required(:description) { filled? & str? & min_size?(10) & max_size?(200) }
          required(:body) { filled? & str? }
          required(:tags) { array? & size?(1..15) & each(:str?) }
          required(:author_id) { filled? & str? & format?(UUID::VALIDATION_REGEX) }
        }

        def self.title(title)
          field_errors(VALIDATOR, :title, title, :title_is_invalid)
        end

        def self.description(description)
          field_errors(VALIDATOR, :description, description, :description_is_invalid)
        end

        def self.body(body)
          field_errors(VALIDATOR, :body, body, :body_is_invalid)
        end

        def self.tags(tags)
          field_errors(VALIDATOR, :tags, tags, :tags_are_invalid)
        end

        def self.author_id(author_id)
          field_errors(VALIDATOR, :author_id, author_id, :author_id_is_invalid)
        end
      end
    end
  end
end
