# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Api
    module Queries
      class ApiIndexProfiles < Colmena::Query
        def call(auth_token:, user_ids:)
          # TODO: Make faster!
          users = user_ids.map do |user_id|
            port(:router).query(:read_user_by_id).call(
              id: user_id,
            ).fetch(:data)
          end

          index = users.map do |user|
            [
              user.fetch(:id),
              port(:router).query(:api_get_profile).call(
                auth_token: auth_token,
                username: user.fetch(:username),
              ).fetch(:data).fetch(:profile),
            ]
          end

          response(Hash[index])
        end
      end
    end
  end
end
