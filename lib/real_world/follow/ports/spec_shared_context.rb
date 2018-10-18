# frozen_string_literal: true

require 'sequel'
require 'real_world/follow/ports/repository/sql'

RSpec.shared_context 'follow ports' do
  let(:repository) do
    RealWorld::Follow::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:ports) do
    {
      repository: repository,
    }
  end
end
