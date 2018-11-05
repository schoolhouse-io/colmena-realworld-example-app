# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module User
    module Queries
      class IndexUsersById < Colmena::Query
        def call(ids:)
          users = port(:repository).index_by_ids(ids)

          response(users)
        end
      end
    end
  end
end
