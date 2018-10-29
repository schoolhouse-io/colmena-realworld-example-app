# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/mappers/json'
require 'real_world/api/http/mappers/auth_token'
require 'real_world/api/http/response'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Articles
          class Create
            include Endpoint
            command :api_create_article

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              title: Mappers::Json.required(:article, :title),
              description: Mappers::Json.required(:article, :description),
              body: Mappers::Json.required(:article, :body),
              tags: Mappers::Json.required(:article, :tagList),
            )

            ISO8601 = ->(time) do
              Time.at(time).utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
            end

            custom_handler ->(result, _env) do
              article = result.fetch(:data).fetch(:article)

              Response.call(
                201,
                article: {
                  title: article.fetch(:title),
                  slug: article.fetch(:slug),
                  description: article.fetch(:description),
                  body: article.fetch(:body),
                  tagList: article.fetch(:tags),
                  author: article.fetch(:author),
                  createdAt: ISO8601.call(article.fetch(:created_at)),
                  updatedAt: ISO8601.call(article.fetch(:updated_at)),
                  favorited: article.fetch(:favorited),
                  favoritesCount: article.fetch(:favorites_count),
                },
              )
            end
          end
        end
      end
    end
  end
end
