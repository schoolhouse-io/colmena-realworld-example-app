# frozen_string_literal: true

require 'real_world/api/http/endpoint'
require 'real_world/api/http/mappers'
require 'real_world/api/http/mappers/json'
require 'real_world/api/http/mappers/auth_token'
require 'real_world/api/http/mappers/route'
require 'real_world/api/http/response'

module RealWorld
  module Api
    module Http
      module Endpoints
        module Comments
          ISO8601 = ->(time) do
            Time.at(time).utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end

          MAP = ->(comment) do
            {
              id: comment.fetch(:id),
              body: comment.fetch(:body),
              author: comment.fetch(:author),
              createdAt: ISO8601.call(comment.fetch(:created_at)),
              updatedAt: ISO8601.call(comment.fetch(:updated_at)),
            }
          end

          RETURN_ONE = ->(result, _env) do
            data = result.fetch(:data)

            Response.call(
              200,
              data.merge(comment: MAP.call(data.fetch(:comment))),
            )
          end

          RETURN_MANY = ->(result, _env) do
            data = result.fetch(:data)

            Response.call(
              200,
              data.merge(
                comments: data.fetch(:comments).map(&MAP),
              ),
            )
          end

          class List
            include Endpoint
            query :api_list_comments

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header(optional: true),
              article_slug: Mappers::Route.segment(:slug),
            )

            custom_handler RETURN_MANY
          end

          class Create
            include Endpoint
            command :api_create_comment

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              article_slug: Mappers::Route.segment(:slug),
              body: Mappers::Json.required(:comment, :body),
            )

            custom_handler RETURN_ONE
          end

          class Delete
            include Endpoint
            command :api_delete_comment

            custom_mapper Mappers.combine(
              auth_token: Mappers::AuthToken.header,
              id: Mappers::Route.segment(:id),
            )

            custom_handler RETURN_ONE
          end
        end
      end
    end
  end
end
