# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Favorite
    module Queries
      class IsFavorited < Colmena::Query
        def call(article_ids:, user_id:)
          response(
            port(:repository).favorited?(article_ids: article_ids, user_id: user_id),
          )
        end
      end
    end
  end
end
