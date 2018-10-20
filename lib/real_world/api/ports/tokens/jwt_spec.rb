# frozen_string_literal: true

require 'real_world/api/ports/tokens/spec_shared_examples'
require 'real_world/api/ports/tokens/jwt'

describe RealWorld::Api::Ports::Tokens::JWT do
  it_behaves_like 'a token manager' do
    subject { described_class.new }
  end
end
