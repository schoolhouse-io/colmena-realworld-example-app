# frozen_string_literal: true

require 'colmena/command'
require 'real_world/favorite/domain'

module RealWorld
  module Favorite
    module Commands
      class Unfavorite < Colmena::Command
        def call(article_id:, user_id:)
          Domain.unfollow(
            port(:repository).read(
              article_id: article_id,
              user_id: user_id,
            ),
          )
        end
      end
    end
  end
end
