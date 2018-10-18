# frozen_string_literal: true

require 'colmena/command'
require 'real_world/user/domain'

module RealWorld
  module User
    module Commands
      class CreateUser < Colmena::Command
        def call(email:, username:, bio:, image:)
          return error_response(:email_already_exists) if port(:repository).read_by_email(email)

          return error_response(:username_already_exists) if port(:repository).read_by_username(username)

          Domain.create(email, username, bio, image)
        end
      end
    end
  end
end
