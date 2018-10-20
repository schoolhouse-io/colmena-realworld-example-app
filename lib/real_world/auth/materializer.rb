# frozen_string_literal: true

require 'colmena/materializer'
require 'real_world/auth/domain'

module RealWorld
  module Auth
    class Materializer < Colmena::Materializer
      def transaction
        port(:repository).transaction { yield }
      end

      def map(event)
        Domain.apply({}, [event])
      end

      def call(event)
        return unless Domain.event?(event[:type])

        credentials = map(event)

        # Immutable strategy
        port(:repository).delete(credentials) if port(:repository).read_by_user_id(credentials.fetch(:user_id))
        port(:repository).create(credentials)
      end
    end
  end
end
