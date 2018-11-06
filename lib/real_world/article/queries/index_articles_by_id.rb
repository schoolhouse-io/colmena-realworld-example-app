# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Article
    module Queries
      class IndexArticlesById < Colmena::Query
        def call(ids:)
          index = port(:repository).index(ids)

          response(index)
        end
      end
    end
  end
end
