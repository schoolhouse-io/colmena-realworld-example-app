# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiListTags < Colmena::Query
        def call(limit: 100, offset: 0)
          list_tags = port(:router).query(:list_tags).call(
            limit: limit,
            offset: offset,
          )

          capture_errors(list_tags) do
            response(
              tags: list_tags.fetch(:data),
              extras: { pagination: list_tags.fetch(:pagination) },
            )
          end
        end
      end
    end
  end
end
