# frozen_string_literal: true

require 'colmena/command'
require 'real_world/user/domain'

module RealWorld
  module User
    module Commands
      class UpdateUser < Colmena::Command
        def call(id:, email:, username:, bio:, image:)
          user = port(:repository).read_by_id(id)
          return error_response(:user_does_not_exist) unless user

          return error_response(:email_already_exists) if port(:repository).read_by_email(email)

          return error_response(:username_already_exists) if port(:repository).read_by_username(username)

          Domain.update(user, email, username, bio, image)
        end
      end
    end
  end
end
