# frozen_string_literal: true

require 'colmena/command'
require 'real_world/comment/domain'

module RealWorld
  module Comment
    module Commands
      class CreateComment < Colmena::Command
        def call(body:, article_id:, author_id:)
          Domain.create(body, article_id, author_id)
        end
      end
    end
  end
end
