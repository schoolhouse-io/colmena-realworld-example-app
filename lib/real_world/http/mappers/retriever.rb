# frozen_string_literal: true

require 'rack'

module RealWorld
  module Http
    module Mappers
      class Retriever
        attr_reader :retrievers

        def initialize(*retrievers)
          @retrievers = retrievers
        end

        def call(param_definitions, env)
          params = {}
          request = Rack::Request.new(env)
          retrievers = @retrievers.map { |retriever| retriever.new(request, env) }

          param_definitions.each do |name:, required:|
            name = name.to_sym
            found = false

            retrievers.each do |retriever|
              value, found, error = retriever.call(name)

              return nil, error if error

              if found
                params[name] = value
                break
              end
            end

            return nil, { type: :param_not_found, data: { name: name } } if required && !found
          end

          return params, nil
        end
      end
    end
  end
end
