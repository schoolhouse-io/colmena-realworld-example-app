# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiIndexProfiles < Colmena::Query
        def call(auth_token:, user_ids:)
          auth_user_id = if auth_token
                           token, error = port(:tokens).decode_auth(auth_token)
                           return error_response(:unauthorized, reason: error) if error

                           token.fetch(:user_id)
                         end

          user_index = port(:router).query(:index_users_by_id).call(
            ids: user_ids,
          ).fetch(:data)

          if auth_user_id
            is_followed_index = port(:router).query(:index_is_followed).call(
              follower_id: auth_user_id,
              followed_ids: user_ids,
            ).fetch(:data)

            user_index = Hash[
              user_index.map do |user_id, user|
                [
                  user_id,
                  user.merge(following: is_followed_index.fetch(user_id)),
                ]
              end
            ]
          end

          response(user_index)
        end
      end
    end
  end
end
