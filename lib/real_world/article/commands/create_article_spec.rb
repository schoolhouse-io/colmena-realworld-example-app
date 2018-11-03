# frozen_string_literal: true

require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/commands/create_article'

describe RealWorld::Article::Commands::CreateArticle do
  include_context 'article ports'
  include_context 'article factory'

  let(:command) { described_class.new(ports) }
  subject do
    command.call(
      title: title,
      description: description,
      body: body,
      tags: tags,
      author_id: author_id,
    )
  end

  it {
    is_expected.to(
      succeed(
        data: include(
          id: be_a(String),
          title: title,
          slug: be_a(String),
          description: description,
          body: body,
          tags: tags,
          author_id: author_id,
        ),
        events: [:article_created] + tags.map { :article_tag_added },
      ),
    )
  }

  context 'when the article slug is taken' do
    before do
      expect(repository).to receive(:read_by_slug).and_return({})
      expect(repository).to receive(:read_by_slug).and_return(nil)
    end

    it 'regenerates the slug' do
      is_expected.to(
        succeed(
          data: include(slug: be_a(String)),
          events: [:article_created] + tags.map { |_| :article_tag_added },
        ),
      )
    end
  end
end
