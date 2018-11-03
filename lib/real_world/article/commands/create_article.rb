# frozen_string_literal: true

require 'colmena/command'
require 'real_world/article/domain'

module RealWorld
  module Article
    module Commands
      class CreateArticle < Colmena::Command
        def call(title:, description:, body:, tags:, author_id:)
          perform_creation = -> do
            Domain.create(
              title,
              description,
              body,
              tags,
              author_id,
            )
          end

          create_article = perform_creation.call

          capture_errors(create_article) do
            # Deal with slug collisions
            5.times do
              break unless port(:repository).read_by_slug(create_article.dig(:data, :slug))

              create_article = perform_creation.call
            end

            create_article
          end
        end
      end
    end
  end
end
