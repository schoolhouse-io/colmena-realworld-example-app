# frozen_string_literal: true

require 'sequel'
require 'real_world/user/ports/repository/sql'
require 'real_world/user/ports/repository/spec_shared_examples'

describe RealWorld::User::Ports::Repository::SQL do
  it_behaves_like 'a user repository' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
