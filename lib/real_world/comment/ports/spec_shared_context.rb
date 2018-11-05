# frozen_string_literal: true

require 'logger'
require 'sequel'
require 'real_world/comment/ports/repository/sql'

RSpec.shared_context 'comment ports' do
  let(:repository) do
    RealWorld::Comment::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:logger) { Logger.new(STDERR, level: Logger::DEBUG) }

  let(:ports) do
    {
      repository: repository,
      logger: logger,
    }
  end
end
