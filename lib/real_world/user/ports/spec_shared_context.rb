# frozen_string_literal: true

require 'logger'
require 'sequel'
require 'real_world/user/ports/repository/sql'

RSpec.shared_context 'user ports' do
  let(:repository) do
    RealWorld::User::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:logger) { Logger.new(STDERR, level: Logger::DEBUG) }

  let(:ports) do
    {
      repository: repository,
      logger: logger,
    }
  end
end
