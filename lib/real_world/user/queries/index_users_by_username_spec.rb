# frozen_string_literal: true

require 'real_world/user/spec_factory_shared_context'
require 'real_world/user/ports/spec_shared_context'
require 'real_world/user/queries/index_users_by_username'

describe RealWorld::User::Queries::IndexUsersByUsername do
  include_context 'user ports'
  include_context 'user factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(usernames: [username]) }

  context 'when the user does not exist' do
    it { is_expected.to succeed(data: eq({})) }
  end

  context 'when the user exists' do
    before { repository.create(some_user) }

    it { is_expected.to succeed(data: include(username => some_user)) }
  end
end
