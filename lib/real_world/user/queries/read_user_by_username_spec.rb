# frozen_string_literal: true

require 'real_world/user/spec_factory_shared_context'
require 'real_world/user/ports/spec_shared_context'
require 'real_world/user/queries/read_user_by_username'

describe RealWorld::User::Queries::ReadUserByUsername do
  include_context 'user ports'
  include_context 'user factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(username: username) }

  context 'when the user does not exist' do
    it { is_expected.to fail_with_errors(:user_does_not_exist) }
  end

  context 'when the user exists' do
    before { repository.create(some_user) }
    it { is_expected.to succeed(data: include(some_user)) }
  end
end
