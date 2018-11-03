# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      class ApiUpdateArticle < Colmena::Command
        def call(auth_token:, slug:, title: nil, description: nil, body: nil, tags: nil)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:forbidden, reason: error) if error

          read_article = port(:router).query(:read_article_by_slug).call(slug: slug)

          capture_errors(read_article) do
            article = read_article.fetch(:data)
            return error_response(:forbidden) unless article.fetch(:author_id) == token.fetch(:user_id)

            update_article = port(:router).command(:update_article).call(
              id: article.fetch(:id),
              title: title,
              description: description,
              body: body,
              tags: tags,
            )

            capture_errors(update_article) do
              article = update_article.fetch(:data)

              response(port(:router).query(:api_get_article).call(
                auth_token: auth_token,
                slug: article.fetch(:slug),
              ).fetch(:data))
            end
          end
        end
      end
    end
  end
end
