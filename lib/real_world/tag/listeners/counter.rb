# frozen_string_literal: true

require 'colmena/listener'

module RealWorld
  module Tag
    module Listeners
      class Counter < Colmena::Listener
        def call(event)
          case event.fetch(:type)
          when :tag_added then port(:repository).increase(event.fetch(:data).fetch(:name))
          when :tag_removed then port(:repository).decrease(event.fetch(:data).fetch(:name))
          end
          # TODO: Log unhandled event
        end
      end
    end
  end
end
