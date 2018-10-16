# frozen_string_literal: true
require 'sequel'
require 'real_world/auth/ports/repository/sql'
require 'real_world/auth/ports/repository/spec_shared_examples'

describe RealWorld::Auth::Ports::Repository::SQL do
  it_behaves_like 'an auth repository' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
