require 'colmena/response'
require 'colmena/error'
require 'colmena/event'

module Colmena
  module Domain
    include Colmena::Response
    include Colmena::Error
    include Colmena::Event

    # Declare types of events and what their effect on the entity is (handler)
    def events(*types, handler:)
      @event_handlers ||= {}
      types.each { |type| @event_handlers[type] = handler }
    end

    def event?(type)
      @event_handlers.key?(type)
    end

    # Apply a sequence of events to an entity
    def apply(entity, events)
      events.inject(entity) do |result, event|
        @event_handlers[event.fetch(:type)].call(result, event)
      end
    end
  end
end
