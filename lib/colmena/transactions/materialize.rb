# frozen_string_literal: true

require 'colmena/transactions'
require 'colmena/materializer'

module Colmena
  module Transactions
    class Materialize
      class Configuration
        def initialize(options = {})
          @materializer = options.fetch(:materializer)
          @options = options
          @config = Colmena::Transactions::Configuration.new(Materialize, options)
        end

        def [](command)
          @config[command]
        end
      end

      def self.[](options = {})
        Configuration.new(options)
      end

      def initialize(ports, materializer:, topic:, attributes: {}, events_port: :event_log)
        # We pass all ports for flexibility, but allow choosing
        # specific ones for certain actions
        @ports = ports
        @events_port = ports.fetch(events_port)

        @materializer = materializer.new(ports)
        @topic = topic
        @attributes = attributes
      end

      def call
        result = yield
        events = result[:events] || []
        materialized_events = []

        events.each do |event|
          @events_port.transaction do |channel|
            @materializer.transaction do
              @materializer.call(event)
              @events_port.publish(@topic, [event], @attributes, channel)
            end
          end

          materialized_events << event
        end

        result
      rescue Colmena::Materializer::KnownError => e
        {
          data: nil,
          events: materialized_events,
          errors: [{ type: e.type, data: e.data }],
        }
      end
    end
  end
end
