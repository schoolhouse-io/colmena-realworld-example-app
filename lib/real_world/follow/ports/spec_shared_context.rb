# frozen_string_literal: true

require 'logger'
require 'sequel'
require 'real_world/follow/ports/repository/sql'

RSpec.shared_context 'follow ports' do
  let(:repository) do
    RealWorld::Follow::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:logger) { Logger.new(STDERR, level: Logger::DEBUG) }

  let(:ports) do
    {
      repository: repository,
      logger: logger,
    }
  end
end
