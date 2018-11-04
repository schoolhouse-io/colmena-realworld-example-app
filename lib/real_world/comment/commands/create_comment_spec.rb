# frozen_string_literal: true

require 'real_world/comment/ports/spec_shared_context'
require 'real_world/comment/spec_factory_shared_context'
require 'real_world/comment/commands/create_comment'

describe RealWorld::Comment::Commands::CreateComment do
  include_context 'comment ports'
  include_context 'comment factory'

  let(:command) { described_class.new(ports) }
  subject do
    command.call(
      body: body,
      author_id: author_id,
      article_id: article_id,
    )
  end

  it {
    is_expected.to(
      succeed(
        data: include(
          id: be_a(String),
          body: body,
          created_at: be_a(Float),
          updated_at: be_a(Float),
          author_id: author_id,
          article_id: article_id,
        ),
        events: [:comment_created],
      ),
    )
  }
end
