# frozen_string_literal: true

require 'colmena/command'

module RealWorld
  module Api
    module Commands
      class ApiCreateComment < Colmena::Command
        def call(auth_token:, article_slug:, body:)
          token, error = port(:tokens).decode_auth(auth_token)
          return error_response(:unauthorized, reason: error) if error

          read_article = port(:router).query(:read_article_by_slug).call(
            slug: article_slug,
          )

          capture_errors(read_article) do
            article = read_article.fetch(:data)

            create_comment = port(:router).command(:create_comment).call(
              body: body,
              article_id: article.fetch(:id),
              author_id: token.fetch(:user_id),
            )

            capture_errors(create_comment) do
              comment = create_comment.fetch(:data)

              author = port(:router).query(:read_user_by_id).call(
                id: comment.fetch(:author_id),
              ).fetch(:data)

              response(
                comment: comment.merge(
                  author: port(:router).query(:api_get_profile).call(
                    auth_token: auth_token,
                    username: author.fetch(:username),
                  ).fetch(:data),
                ),
              )
            end
          end
        end
      end
    end
  end
end
