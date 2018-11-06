# frozen_string_literal: true

require 'sequel'
require 'real_world/feed/ports/repository/sql'
require 'real_world/ports/router/in_memory'

RSpec.shared_context 'feed ports' do
  let(:repository) do
    RealWorld::Feed::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:router) do
    RealWorld::Ports::Router::InMemory.new
  end

  let(:ports) do
    {
      repository: repository,
      router: router,
    }
  end
end
