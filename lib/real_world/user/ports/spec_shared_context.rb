# frozen_string_literal: true

require 'sequel'
require 'real_world/user/ports/repository/sql'

RSpec.shared_context 'user ports' do
  let(:repository) do
    RealWorld::User::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:ports) do
    {
      repository: repository,
    }
  end
end
