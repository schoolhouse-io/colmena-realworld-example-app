# frozen_string_literal: true

require 'rack'

module RealWorld
  module Ports
    module HttpInterface
      class Rack
        def initialize
          @subscribers = subscribers = []

          @app = ::Rack::Builder.new do
            use ::Rack::ContentLength
            use ::Rack::TempfileReaper

            run ->(env) do
              subscribers.reduce(env) { |a, e| e.call(a) }
            end
          end
        end

        def call(env)
          @app.call(env)
        end

        def subscribe(callable, _options = {})
          @subscribers << callable
        end

        def clear
          @subscribers.clear
        end
      end
    end
  end
end
