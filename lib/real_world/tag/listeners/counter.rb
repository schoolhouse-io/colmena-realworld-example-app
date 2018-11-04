# frozen_string_literal: true

require 'colmena/listener'

module RealWorld
  module Tag
    module Listeners
      class Counter < Colmena::Listener
        def call(event)
          case event.fetch(:type)
          when :article_tag_added then port(:repository).increase(event.fetch(:data).fetch(:tag))
          when :article_tag_deleted then port(:repository).decrease(event.fetch(:data).fetch(:tag))
          end
          # TODO: Log unhandled event
        end
      end
    end
  end
end
