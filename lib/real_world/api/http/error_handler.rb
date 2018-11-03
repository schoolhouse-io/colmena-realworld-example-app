# frozen_string_literal: true

require 'real_world/api/http/response'

module RealWorld
  module Api
    module Http
      module ErrorHandler
        def self.call(errors)
          validation = validation_errors(errors)
          return Response.call(422, errors: validation) unless validation.empty?

          Response.call(
            status_code(errors.first),
            errors: Hash[errors.map { |error| error.values_at(:type, :data) }],
          )
        end

        def self.validation_errors(errors)
          Hash[
            errors
              .select { |error| error.fetch(:type).to_s.end_with?('is_invalid') }
              .map do |error|
              [
                error.fetch(:type).to_s.chomp('_is_invalid'),
                error.fetch(:data).join(' and '),
              ]
            end
          ]
        end

        def self.status_code(error)
          type = error.fetch(:type)

          case type
          when :unauthorized then 401
          when :forbidden then 403
          when :param_not_found
            error.dig(:data, :name) == :auth_token ? 401 : 400
          else
            type.to_s.end_with?('not_found') ? 404 : 400
          end
        end
      end
    end
  end
end
