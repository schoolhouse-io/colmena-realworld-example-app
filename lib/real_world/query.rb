# frozen_string_literal: true

module RealWorld
  module Query
    # @param query [#call] A query to be called with the supplied parameters,
    #   and accepting additional 'offset' and 'limit' parameters.
    # @param params [Hash] The basic parameters for the query
    # @param limit [Integer] The number of records to ask for in each call
    # @yield [Array] the data returned by the query
    def self.iterate_paginated(query, limit: 100, **params)
      offset = 0
      all_pages_visited = false

      until all_pages_visited
        result = query.call(params.merge(offset: offset, limit: limit))
        offset += limit
        all_pages_visited = result.fetch(:pagination).fetch(:total_elements) <= offset

        yield(result.fetch(:data))
      end
    end
  end
end
