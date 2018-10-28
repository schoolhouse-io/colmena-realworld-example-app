# frozen_string_literal: true

require 'colmena/error'

module RealWorld
  module Api
    module Http
      module Mappers
        module Route
          def self.segment(name)
            ->(request, _cache) do
              params = request.env['router.params']

              if params&.key?(name)
                [params[name], nil]
              else
                [nil, Colmena::Error.call(:param_not_found, name: name)]
              end
            end
          end
        end
      end
    end
  end
end
