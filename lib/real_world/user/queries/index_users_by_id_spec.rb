# frozen_string_literal: true

require 'real_world/user/spec_factory_shared_context'
require 'real_world/user/ports/spec_shared_context'
require 'real_world/user/queries/index_users_by_id'

describe RealWorld::User::Queries::IndexUsersById do
  include_context 'user ports'
  include_context 'user factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(ids: [id]) }

  context 'when the user does not exist' do
    it { is_expected.to succeed(data: eq({})) }
  end

  context 'when the user exists' do
    before { repository.create(some_user) }

    it { is_expected.to succeed(data: include(id => some_user)) }
  end
end
