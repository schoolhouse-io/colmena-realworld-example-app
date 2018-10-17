# frozen_string_literal: true

require 'colmena/command'
require 'real_world/user/domain'

module RealWorld
  module User
    module Commands
      class CreateUser < Colmena::Command
        def call(email:, username:, bio:, image:)
          if port(:repository).read_by_email(email)
            return error_response(:email_already_exists)
          end

          if port(:repository).read_by_username(username)
            return error_response(:username_already_exists)
          end

          Domain.create(email, username, bio, image)
        end
      end
    end
  end
end
