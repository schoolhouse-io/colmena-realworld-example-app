# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Comment
    module Queries
      class ReadCommentById < Colmena::Query
        def call(id:)
          comment = port(:repository).read_by_id(id)
          return error_response(:comment_does_not_exist) unless comment

          response(comment)
        end
      end
    end
  end
end
