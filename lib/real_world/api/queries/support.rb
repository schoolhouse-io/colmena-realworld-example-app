# frozen_string_literal: true

module RealWorld
  module Api
    module Queries
      module Support
        def self.user_to_profile(user, following:)
          user.slice(
            :username,
            :bio,
            :image,
          ).merge(
            following: following,
          )
        end
      end
    end
  end
end
