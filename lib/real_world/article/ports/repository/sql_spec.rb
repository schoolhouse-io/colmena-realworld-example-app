# frozen_string_literal: true

require 'sequel'
require 'real_world/article/ports/repository/sql'
require 'real_world/article/ports/repository/spec_shared_examples'

describe RealWorld::Article::Ports::Repository::SQL do
  it_behaves_like 'an article repository' do
    subject do
      described_class.new(Sequel.connect('sqlite:memory'), unsafe: true)
    end
  end
end
