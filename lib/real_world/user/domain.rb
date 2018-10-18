# frozen_string_literal: true

require 'securerandom'
require 'colmena/domain'
require 'real_world/user/domain/validation'

module RealWorld
  module User
    module Domain
      extend Colmena::Domain

      events :user_created,
             :user_updated,
             handler: ->(user, event) { user.merge(event.fetch(:data)) }

      def self.create(email, username, bio, image)
        user = {
          id: SecureRandom.uuid,
          email: email,
          username: username,
          bio: bio,
          image: image,
        }

        capture_errors(
          Validation.email(email),
          Validation.username(username),
          Validation.bio(bio),
          Validation.image(image),
        ) do
          response(
            user,
            events: [event(:user_created, user)],
          )
        end
      end

      def self.update(user, email, username, bio, image)
        updated_user = user.merge(
          email: email,
          username: username,
          bio: bio,
          image: image,
        )

        capture_errors(
          Validation.email(email),
          Validation.username(username),
          Validation.bio(bio),
          Validation.image(image),
        ) do
          response(
            updated_user,
            events: [event(:user_updated, updated_user)],
          )
        end
      end
    end
  end
end
