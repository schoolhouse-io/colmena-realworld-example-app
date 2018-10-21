# frozen_string_literal: true

require 'sequel'
require 'real_world/tag/ports/repository/sql'
require 'real_world/tag/ports/repository/spec_shared_examples'

describe RealWorld::Tag::Ports::Repository::SQL do
  it_behaves_like 'a tag repository' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
