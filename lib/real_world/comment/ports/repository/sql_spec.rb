# frozen_string_literal: true

require 'sequel'
require 'real_world/comment/ports/repository/sql'
require 'real_world/comment/ports/repository/spec_shared_examples'

describe RealWorld::Comment::Ports::Repository::SQL do
  it_behaves_like 'a comment repository' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
