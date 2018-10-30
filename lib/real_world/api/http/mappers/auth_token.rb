# frozen_string_literal: true

require 'colmena/error'

module RealWorld
  module Api
    module Http
      module Mappers
        module AuthToken
          def self.header(optional: false)
            ->(request, _cache) do
              type, token = request.env['HTTP_AUTHORIZATION'].split

              if type == 'Token'
                [token, nil]
              else
                [
                  nil,
                  if optional
                    nil
                  else
                    Colmena::Error.new(
                      :forbidden,
                      reason: "An Authentication header of type 'Token' was not provided",
                    )
                  end,
                ]
              end
            end
          end
        end
      end
    end
  end
end
