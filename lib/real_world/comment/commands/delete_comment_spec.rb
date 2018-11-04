# frozen_string_literal: true

require 'real_world/comment/ports/spec_shared_context'
require 'real_world/comment/spec_factory_shared_context'
require 'real_world/comment/commands/delete_comment'
require 'securerandom'

describe RealWorld::Comment::Commands::DeleteComment do
  include_context 'comment ports'
  include_context 'comment factory'

  let(:command) { described_class.new(ports) }

  subject { command.call(id: id) }

  context 'when the comment does not exist' do
    it { is_expected.to fail_with_errors(:comment_does_not_exist) }
  end

  context 'when the comment exists' do
    before { repository.create(some_comment) }

    it {
      is_expected.to(
        succeed(
          data: be(nil),
          events: [:comment_deleted],
        ),
      )
    }
  end
end
