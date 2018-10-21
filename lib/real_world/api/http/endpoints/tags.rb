# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/mappers/query_param'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Tags
          class List
            include Endpoint
            query :api_list_tags

            custom_mapper Mappers.combine(
              limit: Mappers::QueryParam.optional(:limit, type: Integer),
              offset: Mappers::QueryParam.optional(:offset, type: Integer),
            )
          end
        end
      end
    end
  end
end
