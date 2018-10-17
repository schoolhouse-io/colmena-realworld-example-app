# frozen_string_literal: true

require 'real_world/http/mappers/retriever'
require 'real_world/http/mappers/retriever/json'
require 'real_world/http/mappers/retriever/uri'

module RealWorld
  module Api
    module Http
      module Mappers
        RETRIEVE = RealWorld::Http::Mappers::Retriever.new(
          RealWorld::Http::Mappers::Retriever::URI,
          RealWorld::Http::Mappers::Retriever::JSON,
        )
      end
    end
  end
end
