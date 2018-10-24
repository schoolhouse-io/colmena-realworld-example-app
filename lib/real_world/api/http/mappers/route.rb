# frozen_string_literal: true

require 'colmena/error'

module RealWorld
  module Api
    module Http
      module Mappers
        module Route
          extend Colmena::Error

          def self.segment(name)
            ->(request, _cache) do
              params = request.env['router.params']

              if params&.key?(name)
                [params[name], nil]
              else
                [nil, error(:param_not_found, name: name)]
              end
            end
          end
        end
      end
    end
  end
end
