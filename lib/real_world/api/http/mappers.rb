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
      end
    end
  end
end
