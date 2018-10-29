# frozen_string_literal: true

require 'colmena/command'
require 'real_world/article/domain'

module RealWorld
  module Article
    module Commands
      class CreateArticle < Colmena::Command
        def call(title:, description:, body:, tags:, author_id:)
          create_article = Domain.create(
            title,
            description,
            body,
            tags,
            author_id,
          )

          capture_errors(create_article) do
            # Deal with slug collisions
            while port(:repository).read_by_slug(create_article.dig(:data, :slug))
              create_article = Domain.create(
                title,
                description,
                body,
                tags,
                author_id,
              )
            end

            create_article
          end
        end
      end
    end
  end
end
