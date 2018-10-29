# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      class ApiCreateArticle < Colmena::Command
        def call(auth_token:, title:, description:, body:, tags:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:forbidden, reason: error) if error

          create_article = port(:router).command(:create_article).call(
            title: title,
            description: description,
            body: body,
            tags: tags,
            author_id: token.fetch(:user_id),
          )

          capture_errors(create_article) do
            article = create_article.fetch(:data)

            author = port(:router).query(:read_user_by_id).call(
              id: article.fetch(:author_id),
            ).fetch(:data)

            response(article: article.merge(
              author: author,
              favorited: false,
              favorites_count: 0,
            ))
          end
        end
      end
    end
  end
end
