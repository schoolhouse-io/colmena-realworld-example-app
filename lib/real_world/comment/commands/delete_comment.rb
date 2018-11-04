# frozen_string_literal: true

require 'colmena/command'
require 'real_world/comment/domain'

module RealWorld
  module Comment
    module Commands
      class DeleteComment < Colmena::Command
        def call(id:)
          comment = port(:repository).read_by_id(id)
          Domain.delete(comment)
        end
      end
    end
  end
end
