# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module User
    module Queries
      class ReadUserByEmail < Colmena::Query
        def call(email:)
          user = port(:repository).read_by_email(email)
          return error_response(:user_does_not_exist) unless user

          response(user)
        end
      end
    end
  end
end
