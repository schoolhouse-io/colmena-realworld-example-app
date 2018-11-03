# frozen_string_literal: true

require 'sequel'
require 'real_world/comment/ports/repository/sql'

RSpec.shared_context 'comment ports' do
  let(:repository) do
    RealWorld::Comment::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:ports) do
    {
      repository: repository,
    }
  end
end
