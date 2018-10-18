# frozen_string_literal: true

module RealWorld
  module Ports
    #
    # The EventBroker port is responsible for the publication and subscription
    # to streams of events under certain topics
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
          @topics = {}
          @subscribers = {}
        end

        # Publishes a series of events under a certain topic and returns
        # the published events. If the topic did not exist beforehand,
        # it creates it
        #
        # @param topic [Symbol] The name of the topic
        # @param events [Array<Event>] An array of events to publish
        # @param attributes [#call(Event), Hash] A callback to obtain the
        #   attributes the event should be linked with (e.g. the user_id or the
        #   medgroup_id) so that listeners can fine-grain their subscription),
        #   or a hash containing the attributes
        # @return [Array<EventInTopic>] An array containing the
        #   published events in the same order as received
        def publish(topic, events, attributes = {}, *)
          if @within_transaction
            @buffer << [topic, events, attributes]
            events
          else
            publish!(topic, events, attributes)
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

        # Asks whether a given topic exists
        #
        # @param name [Symbol] The name of the topic
        # @return [True, False]
        def topic?(name)
          @topics.key?(name.to_sym)
        end

        # Subscribes a block to a topic. The block will be called whenever
        # a new event is published under such topic
        #
        # @param topic [Symbol] The name of the topic
        # @param callback [#call] A block to be called with the published
        #   event as the only parameter
        # @return [True]
        def subscribe(callback, topic:, attributes: {}, **)
          subscribers(topic) << [callback, attributes]
          true
        end

        # Clears all the topics and subscribers from the system
        #
        # @param topic [Symbol] The name of the topic
        def clear(topic)
          @topics.delete(topic)
          @subscribers.delete(topic)
        end

        private

        def subscribers(topic)
          @subscribers[topic.to_sym] ||= []
        end

        def publish!(topic, events, attributes)
          @topics[topic.to_sym] = true # Create topic

          events.each do |event|
            subscribers(topic).each do |callback, expected_attrs|
              attrs = attributes.respond_to?(:call) ? attributes.call(event) : attributes
              attrs[:type] = event[:type].to_s

              callback.call(event) if match_all?(attrs, expected_attrs)
            end
          end
        end

        def match_all?(attrs, expected_attrs)
          expected_attrs.all? { |name, value| attrs[name] == value }
        end
      end
    end
  end
end
