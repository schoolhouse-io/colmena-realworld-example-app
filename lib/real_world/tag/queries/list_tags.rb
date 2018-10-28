# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Tag
    module Queries
      class ListTags < Colmena::Query
        def call(limit: 100, offset: 0)
          tags, pagination_info = port(:repository).list(
            limit: limit,
            offset: offset,
          )

          response(tags, extras: { pagination: pagination_info })
        end
      end
    end
  end
end
