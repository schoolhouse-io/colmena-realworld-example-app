# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/mappers/json'
require 'real_world/api/http/mappers/auth_token'
require 'real_world/api/http/mappers/route'
require 'real_world/api/http/mappers/query_param'
require 'real_world/api/http/response'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Articles
          ISO8601 = ->(time) do
            Time.at(time).utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end

          MAP = ->(article) do
            {
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
            }
          end

          RETURN_ONE = ->(result, _env) do
            data = result.fetch(:data)

            Response.call(
              200,
              data.merge(article: MAP.call(data.fetch(:article))),
            )
          end

          RETURN_MANY = ->(result, _env) do
            data = result.fetch(:data)

            Response.call(
              200,
              data.merge(
                articles: data.fetch(:articles).map(&MAP),
                articlesCount: data.dig(:extras, :pagination, :total_elements),
              ),
            )
          end

          class List
            include Endpoint
            query :api_list_articles

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header(optional: true),
              author: Mappers::QueryParam.optional(:author),
              tag: Mappers::QueryParam.optional(:tag),
              favorited: Mappers::QueryParam.optional(:favorited),
              limit: Mappers::QueryParam.optional(:limit, type: Integer),
              offset: Mappers::QueryParam.optional(:offset, type: Integer),
            )

            custom_handler RETURN_MANY
          end

          class Feed
            include Endpoint
            query :api_list_articles_feed

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              limit: Mappers::QueryParam.optional(:limit, type: Integer),
              offset: Mappers::QueryParam.optional(:offset, type: Integer),
            )

            custom_handler RETURN_MANY
          end

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

            custom_handler RETURN_ONE
          end

          class Update
            include Endpoint
            command :api_update_article

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              slug: Mappers::Route.segment(:slug),
              title: Mappers::Json.optional(:article, :title),
              description: Mappers::Json.optional(:article, :description),
              body: Mappers::Json.optional(:article, :body),
              tags: Mappers::Json.optional(:article, :tagList),
            )

            custom_handler RETURN_ONE
          end

          class Get
            include Endpoint
            query :api_get_article

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header(optional: true),
              slug: Mappers::Route.segment(:slug),
            )

            custom_handler RETURN_ONE
          end

          class Favorite
            include Endpoint
            command :api_favorite_article

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              slug: Mappers::Route.segment(:slug),
            )

            custom_handler RETURN_ONE
          end

          class Unfavorite
            include Endpoint
            command :api_unfavorite_article

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              slug: Mappers::Route.segment(:slug),
            )

            custom_handler RETURN_ONE
          end
        end
      end
    end
  end
end
