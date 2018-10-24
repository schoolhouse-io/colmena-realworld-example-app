# frozen_string_literal: true

require 'colmena/response'
require 'colmena/error'
require 'colmena/transactions'
require 'colmena/materializer'

module Colmena
  module Transactions
    # A materialization transaction is meant to wrap/decorate a command.
    # It makes sure 2 things happen transactionally:
    #   1. The events that result from the command are materialized (i.e. they
    #      have a synchronous effect on the state of the app; usually, this means
    #      they are stored in a database)
    #   2. The events that result from the command are published, so that
    #      asynchronous observers can react to them
    class Materialize
      include Colmena::Response
      include Colmena::Error

      class Configuration
        def initialize(options = {})
          @event_materializer = options.fetch(:event_materializer)
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

      # @param ports [Hash<Symbol, Port>] the ports injected to the cell at runtime.
      #   It's supposed to wrap/decorate a command, and thus receives the same ports
      #   as the rest of the cell
      # @param event_materializer [Colmena::Materializer] the particular materializer
      #   that will process those events synchronously
      # @param event_stream [Symbol] the name of the event stream to publish to
      # @param event_publisher [Symbol] the name of the port that will be used to publish
      #   the events
      def initialize(ports, event_materializer:, event_stream:, event_publisher: :event_publisher)
        # We pass all ports for flexibility, but allow choosing
        # specific ones for certain actions
        @ports = ports
        @event_publisher = ports.fetch(event_publisher)
        @event_stream = event_stream
        @event_materializer = event_materializer.new(ports)
      end

      def call
        result = yield
        events = result[:events] || []
        materialized_events = []

        events.each do |event|
          @event_publisher.transaction do
            @event_materializer.transaction do
              @event_materializer.call(event)
              @event_publisher.publish(@event_stream, [event])
            end
          end

          materialized_events << event
        end

        result
      rescue Colmena::Materializer::KnownError => e
        response(nil, events: materialized_events, errors: error(e.type, e.data))
      end
    end
  end
end
