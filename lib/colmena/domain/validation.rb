# frozen_string_literal: true

require 'colmena/response'

module Colmena
  module Domain
    module Validation
      include Colmena::Response

      def field_errors(validator, attribute, value, error_type)
        messages = validator.call(attribute => value).messages.fetch(attribute, [])
        return response(nil) if messages.empty?

        error_response(error_type, messages)
      end
    end
  end
end
