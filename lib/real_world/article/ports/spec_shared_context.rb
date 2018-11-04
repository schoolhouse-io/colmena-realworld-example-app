# frozen_string_literal: true

require 'sequel'
require 'real_world/article/ports/repository/sql'

RSpec.shared_context 'article ports' do
  let(:repository) do
    RealWorld::Article::Ports::Repository::SQL.new(Sequel.connect('sqlite:memory'), unsafe: true)
  end

  let(:ports) do
    {
      repository: repository,
    }
  end
end
