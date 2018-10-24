# frozen_string_literal: true

module RealWorld
  module Ports
    #
    # The EventBroker port is responsible for the publication and subscription
    # to streams of events under certain streams
    #
    # This interface covers basic interaction with the broker. Complex
    # scenarios should use more sophisticated producer/consumer interfaces
    module EventBroker
      #
      # In-memory implementation of an event broker. It is not thread safe or
      # distributed and should only be used in testing scenarios
      #
      # @see EventBroker
      class InMemory
        # Creates a new in-memory event broker with a clean state
        def initialize
          @streams = {}
          @subscribers = {}
        end

        # Publishes a series of events under a certain stream and returns
        # the published events. If the stream did not exist beforehand,
        # it creates it
        #
        # @param stream [Symbol] The name of the stream
        # @param events [Array<Event>] An array of events to publish
        # @return [Array<EventInStream>] An array containing the
        #   published events in the same order as received
        def publish(stream, events)
          if @within_transaction
            @buffer << [stream, events]
            events
          else
            publish!(stream, events)
          end
        end

        # Executes the given block within a transaction
        def transaction
          @within_transaction = true
          @buffer = []
          yield
        rescue ::Object
          @buffer.clear
          raise
        ensure
          @buffer.each { |params| publish!(*params) }
          @buffer.clear
          @within_transaction = false
        end

        # Asks whether a given stream exists
        #
        # @param name [Symbol] The name of the stream
        # @return [True, False]
        def stream?(name)
          @streams.key?(name.to_sym)
        end

        # Subscribes a block to a stream. The block will be called whenever
        # a new event is published under such stream
        #
        # @param stream [Symbol] The name of the stream
        # @param callback [#call] A block to be called with the published
        #   event as the only parameter
        # @return [True]
        def subscribe(callback, stream:)
          subscribers(stream) << callback
          true
        end

        # Clears all the streams and subscribers from the system
        #
        # @param stream [Symbol] The name of the stream
        def clear(stream)
          @streams.delete(stream)
          @subscribers.delete(stream)
        end

        private

        def subscribers(stream)
          @subscribers[stream.to_sym] ||= []
        end

        def publish!(stream, events)
          @streams[stream.to_sym] = true # Create stream

          events.each do |event|
            subscribers(stream).each do |callback|
              callback.call(event)
            end
          end
        end
      end
    end
  end
end
