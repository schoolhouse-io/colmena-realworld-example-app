# frozen_string_literal: true

require 'colmena/command'
require 'real_world/article/domain'

module RealWorld
  module Article
    module Commands
      class UnfavoriteArticle < Colmena::Command
        def call(id:, user_id:)
          article = port(:repository).read_by_id(id)
          return error_response(:article_does_not_exist, id: id) unless article

          favorites = port(:repository).favorited?(article_ids: [id], user_id: user_id)
          return error_response(:article_not_favorited) unless favorites[id]

          Domain.unfavorite(article, user_id)
        end
      end
    end
  end
end
