# frozen_string_literal: true

require 'colmena/command'
require 'real_world/user/domain'

module RealWorld
  module User
    module Commands
      class UpdateUser < Colmena::Command
        def call(id:, email: nil, username: nil, bio: nil, image: nil)
          user = port(:repository).read_by_id(id)
          return error_response(:user_does_not_exist) unless user

          if email && email != user.fetch(:email) && port(:repository).read_by_email(email)
            return error_response(:email_already_exists)
          end

          if username && username != user.fetch(:username) && port(:repository).read_by_username(username)
            return error_response(:username_already_exists)
          end

          Domain.update(
            user,
            email || user.fetch(:email),
            username || user.fetch(:username),
            bio || user.fetch(:bio),
            image || user.fetch(:image),
          )
        end
      end
    end
  end
end
