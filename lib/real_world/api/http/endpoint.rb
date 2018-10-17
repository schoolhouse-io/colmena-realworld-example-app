# frozen_string_literal: true

require 'real_world/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/handlers'
require 'real_world/api/http/error_handler'

module RealWorld
  module Api
    module Http
      module Endpoint
        def self.included(klass)
          klass.include RealWorld::Http::Endpoint

          klass.custom_mapper Mappers::RETRIEVE
          klass.custom_handler Handlers::DEFAULT
          klass.custom_error_handler ErrorHandler
        end
      end
    end
  end
end
