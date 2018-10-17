# frozen_string_literal: true

require 'json'

module RealWorld
  module Http
    module Mappers
      class Retriever
        class JSON
          def initialize(request, _env)
            @request = request
          end

          def call(name)
            [json[name], json.key?(name), nil]
          end

          def json
            @json ||= ::JSON.parse(@request.body.read.to_s, symbolize_names: true)
          rescue ::JSON::ParserError
            @json ||= {}
          end
        end
      end
    end
  end
end
