# frozen_string_literal: true

require 'real_world/article/ports/spec_shared_context'
require 'real_world/article/spec_factory_shared_context'
require 'real_world/article/commands/update_article'

describe RealWorld::Article::Commands::UpdateArticle do
  include_context 'article ports'
  include_context 'article factory'

  let(:command) { described_class.new(ports) }
  subject do
    command.call(
      id: id,
      title: 'Other title',
      description: description,
      body: body,
      tags: tags,
    )
  end

  context 'when the article does not exist' do
    it { is_expected.to fail_with_errors(:article_does_not_exist) }
  end

  context 'when the article exists' do
    before { repository.create(some_article) }

    it {
      is_expected.to(
        succeed(
          data: include(
            id: be_a(String),
            title: 'Other title',
            slug: be_a(String),
            description: description,
            body: body,
            tags: tags,
            author_id: author_id,
          ),
          events: [:article_updated],
        ),
      )
    }

    context 'when the new article slug is taken' do
      before do
        expect(repository).to receive(:read_by_slug).and_return({})
        expect(repository).to receive(:read_by_slug).and_return(nil)
      end

      it 'regenerates the slug' do
        is_expected.to(
          succeed(
            data: include(slug: be_a(String)),
            events: [:article_updated],
          ),
        )
      end
    end
  end
end
