# frozen_string_literal: true

module RealWorld
  module Api
    module Http
      module Mappers
        def self.combine(mappers)
          ->(env) do
            params = {}
            request = Rack::Request.new(env)
            cache = {}

            mappers.each do |name, mapper|
              value, error = mapper.call(request, cache)
              return nil, error if error

              params[name] = value
            end

            return params, nil
          end
        end

        module Json
          def self.at(*path)
            ->(request, cache) do
              cache[:json] ||= begin
                                 JSON.parse(request.body.read.to_s, symbolize_names: true)
                               rescue ::JSON::ParserError
                                 {}
                               end

              begin
                [path.reduce(cache[:json]) { |a, e| a.fetch(e) }, nil]
              rescue ::KeyError => e
                [nil, error(:param_not_found, name: e.key)]
              end
            end
          end
        end
      end
    end
  end
end
