# frozen_string_literal: true

require 'colmena/command'
require 'real_world/article/domain'

module RealWorld
  module Article
    module Commands
      class UpdateArticle < Colmena::Command
        def call(id:, title: nil, description: nil, body: nil, tags: nil)
          article = port(:repository).read_by_id(id)
          return error_response(:article_not_found, id: id) unless article

          perform_update = -> do
            Domain.update(
              article,
              title || article.fetch(:title),
              description || article.fetch(:description),
              body || article.fetch(:body),
              tags || article.fetch(:tags),
            )
          end

          update_article = perform_update.call

          capture_errors(update_article) do
            unless article.fetch(:slug) == update_article.fetch(:data).fetch(:slug)
              # Deal with slug collisions
              while port(:repository).read_by_slug(update_article.dig(:data, :slug))
                update_article = perform_update.call
              end
            end

            update_article
          end
        end
      end
    end
  end
end
