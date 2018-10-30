# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Favorite
    module Queries
      class CountFavorites < Colmena::Query
        def call(article_ids:)
          response(port(:repository).count(article_ids: article_ids))
        end
      end
    end
  end
end
