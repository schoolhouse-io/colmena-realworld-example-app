# frozen_string_literal: true

require 'digest'
require 'colmena/domain'
require 'real_world/auth/domain/validation'

module RealWorld
  module Auth
    module Domain
      extend Colmena::Domain

      events :auth_credentials_created,
             handler: ->(credentials, event) { credentials.merge(event.fetch(:data)) }

      def self.create_credentials(user_id, password)
        capture_errors(Validation.user_id(user_id), Validation.password(password)) do
          encrypted_credentials = encrypt_credentials(user_id: user_id, password: password)

          response(
            encrypted_credentials,
            events: [event(:auth_credentials_created, encrypted_credentials)],
          )
        end
      end

      def self.match?(credentials, password)
        credentials.fetch(:password) == encrypt_password(password, credentials.fetch(:salt))
      end

      def self.encrypt_credentials(credentials)
        salt = Array.new(8) { [*'a'..'z'].sample }.join

        credentials.merge(
          password: encrypt_password(credentials.fetch(:password), salt),
          salt: salt,
        )
      end

      def self.encrypt_password(password, salt)
        Digest::SHA2.new(512).hexdigest([password, salt].join)
      end
    end
  end
end
