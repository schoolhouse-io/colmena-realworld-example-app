# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module User
    module Queries
      class IndexUsersByUsername < Colmena::Query
        def call(usernames:)
          users = port(:repository).index_by_usernames(usernames)

          response(users)
        end
      end
    end
  end
end
