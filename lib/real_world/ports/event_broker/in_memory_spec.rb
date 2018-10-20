# frozen_string_literal: true

require 'real_world/ports/event_broker/in_memory'
require 'real_world/ports/event_broker/spec_shared_examples'

describe RealWorld::Ports::EventBroker::InMemory do
  it_behaves_like 'an event broker' do
    subject { described_class.new }
  end
end
