# frozen_string_literal: true

require 'real_world/comment/spec_factory_shared_context'
require 'real_world/comment/ports/spec_shared_context'
require 'real_world/comment/queries/read_comment_by_id'

describe RealWorld::Comment::Queries::ReadCommentById do
  include_context 'comment ports'
  include_context 'comment factory'

  let(:query) { described_class.new(ports) }
  subject { query.call(id: id) }

  context 'when the comment does not exist' do
    it { is_expected.to fail_with_errors(:comment_does_not_exist) }
  end

  context 'when the comment exists' do
    before { repository.create(some_comment) }
    it { is_expected.to succeed(data: include(some_comment)) }
  end
end
