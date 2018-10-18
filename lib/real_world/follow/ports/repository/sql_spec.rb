# frozen_string_literal: true

require 'sequel'
require 'real_world/follow/ports/repository/sql'
require 'real_world/follow/ports/repository/spec_shared_examples'

describe RealWorld::Follow::Ports::Repository::SQL do
  it_behaves_like 'a repository for following relationships' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
