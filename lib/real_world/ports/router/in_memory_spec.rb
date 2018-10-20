# frozen_string_literal: true

require 'real_world/ports/router/in_memory'
require 'real_world/ports/router/spec_shared_examples'

describe RealWorld::Ports::Router::InMemory do
  it_behaves_like 'a router' do
    subject { described_class.new }
  end
end
