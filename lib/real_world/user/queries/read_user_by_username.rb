# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module User
    module Queries
      class ReadUserByUsername < Colmena::Query
        def call(username:)
          user = port(:repository).read_by_username(username)
          return error_response(:user_does_not_exist) unless user

          response(user)
        end
      end
    end
  end
end
