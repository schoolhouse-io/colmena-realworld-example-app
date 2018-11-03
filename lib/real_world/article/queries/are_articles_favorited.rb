# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Article
    module Queries
      class AreArticlesFavorited < Colmena::Query
        def call(article_ids:, user_id:)
          index = port(:repository).favorited?(article_ids: article_ids, user_id: user_id)

          response(index)
        end
      end
    end
  end
end
