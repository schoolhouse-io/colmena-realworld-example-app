# frozen_string_literal: true

require 'sequel'
require 'real_world/feed/ports/repository/sql'
require 'real_world/feed/ports/repository/spec_shared_examples'

describe RealWorld::Feed::Ports::Repository::SQL do
  it_behaves_like 'a feed repository' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
