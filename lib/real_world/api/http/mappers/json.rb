# frozen_string_literal: true

require 'json'
require 'colmena/error'

module RealWorld
  module Api
    module Http
      module Mappers
        module Json
          def self.required(*path)
            at(*path, required: true)
          end

          def self.optional(*path)
            at(*path, required: false)
          end

          def self.at(*path, required:)
            ->(request, cache) do
              cache[:json] ||= begin
                                 JSON.parse(request.body.read.to_s, symbolize_names: true)
                               rescue ::JSON::ParserError
                                 {}
                               end

              begin
                [path.reduce(cache[:json]) { |a, e| a.fetch(e) }, nil]
              rescue ::KeyError => e
                [nil, required ? Colmena::Error.new(:param_not_found, name: e.key) : nil]
              end
            end
          end
        end
      end
    end
  end
end
