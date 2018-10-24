# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module User
    module Queries
      class ReadUserById < Colmena::Query
        def call(id:)
          user = port(:repository).read_by_id(id)
          return error_response(:user_does_not_exist) unless user

          response(user)
        end
      end
    end
  end
end
