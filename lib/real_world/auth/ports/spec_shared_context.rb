# frozen_string_literal: true

require 'sequel'
require 'real_world/auth/ports/repository/sql'

RSpec.shared_context 'auth ports' do
  let(:repository) do
    RealWorld::Auth::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:ports) do
    {
      repository: repository,
    }
  end
end
