# frozen_string_literal: true

require 'colmena/error'

module RealWorld
  module Api
    module Http
      module Mappers
        module QueryParam
          def self.optional(name, type: String)
            param(name, required: false, type: type)
          end

          def self.param(name, required:, type:)
            ->(request, _cache) do
              value = request.params[name.to_s]

              if value.nil?
                if required
                  [nil, Colmena::Error.call(:param_not_found, name: name)]
                else
                  [nil, nil]
                end
              else
                coerced_value = coerce_string_to(value, type)

                if coerced_value
                  [coerced_value, nil]
                else
                  [nil, Colmena::Error.call(:invalid_param, name: name, reason: "Expected a value of type #{type}")]
                end
              end
            end
          end

          def self.coerce_string_to(value, type)
            case type
            when String then value
            when Integer then Integer(value)
            when Float then Float(value)
            when TrueClass, FalseClass then ['t', 'true', '1'].include?(value.downcase)
            end
          rescue ArgumentError
            nil
          end
        end
      end
    end
  end
end
