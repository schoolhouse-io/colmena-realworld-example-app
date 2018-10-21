# frozen_string_literal: true

require 'sequel'
require 'real_world/tag/ports/repository/sql'

RSpec.shared_context 'tag ports' do
  let(:repository) do
    RealWorld::Tag::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:ports) do
    {
      repository: repository,
    }
  end
end
