# frozen_string_literal: true

require 'securerandom'
require 'real_world/article/spec_factory_shared_context'

RSpec.shared_examples 'an article repository' do
  include_context 'article factory'

  before { subject.clear }

  context 'when there are no articles stored' do
    it '#create' do
      expect { subject.create(some_article) }.not_to raise_error
    end

    it '#read_by_id' do
      expect(subject.read_by_id(id)).to be(nil)
    end

    it '#read_by_slug' do
      expect(subject.read_by_slug(slug)).to be(nil)
    end
  end

  context 'when there is an article' do
    before { subject.create(some_article) }

    let(:different_id) { SecureRandom.uuid }
    let(:different_slug) { 'different-slug' }
    let(:different_tag) { 'different-tag' }
    let(:different_author) { SecureRandom.uuid }
    let(:some_user) { SecureRandom.uuid }

    describe '#create' do
      context 'when the id is duplicated' do
        it 'raises an exception' do
          expect {
            subject.create(some_article.merge(slug: different_slug))
          }.to raise_error(StandardError)
        end
      end

      context 'when the slug is duplicated' do
        it 'raises an exception' do
          expect {
            subject.create(some_user.merge(id: different_id))
          }.to raise_error(StandardError)
        end
      end
    end

    it '#update' do
      new_article = some_article.merge(description: 'Another description')

      subject.update(new_article)
      expect(subject.read_by_id(id)).to eq(new_article)
    end

    it '#read_by_id' do
      expect(subject.read_by_id(id)).to eq(some_article)
    end

    it '#read_by_slug' do
      expect(subject.read_by_slug(slug)).to eq(some_article)
    end

    context 'when the article has not been favorited by some user' do
      it '#favorite' do
        subject.favorite(some_article, some_user)

        expect(subject.favorited?(article_ids: [id], user_id: some_user)).to eq(
          id => true,
        )
      end
    end

    context 'when the article has been favorited by some user' do
      before { subject.favorite(some_article, some_user) }

      it '#favorite' do
        expect {
          subject.favorite(some_article, some_user)
        }.to raise_error(StandardError)
      end

      it '#unfavorite' do
        subject.unfavorite(some_article, some_user)

        expect(subject.favorited?(article_ids: [id], user_id: some_user)).to eq(
          id => false,
        )
      end
    end

    context 'when there are a few articles stored' do
      let(:another_article) do
        some_article.merge(
          id: different_id,
          slug: different_slug,
          tags: [different_tag],
          author_id: different_author,
          created_at: some_article.fetch(:created_at) - 1,
        )
      end

      before do
        subject.create(another_article)
        subject.favorite(some_article, some_user)
      end

      describe '#list' do
        it 'returns a list of articles ordered by creation time' do
          articles, = subject.list
          expect(articles).to eq([some_article, another_article])
        end

        it 'can filter by author' do
          articles, = subject.list(author_id: different_author)
          expect(articles).to eq([another_article])
        end

        it 'can filter by tag' do
          articles, = subject.list(tag: different_tag)
          expect(articles).to eq([another_article])
        end

        it 'can filter by user\'s favorites' do
          articles, = subject.list(favorited_by: some_user)
          expect(articles).to eq([some_article])
        end

        it 'supports pagination' do
          articles, pagination_info = subject.list(limit: 30, offset: 2)
          expect(articles).to be_empty
          expect(pagination_info).to include(limit: 30, offset: 2, total_elements: 2)
        end
      end

      it '#favorited?' do
        expect(subject.favorited?(
                 article_ids: [some_article.fetch(:id), another_article.fetch(:id)],
                 user_id: some_user,
               )).to eq(
                 some_article.fetch(:id) => true,
                 another_article.fetch(:id) => false,
               )
      end
    end
  end
end
