# frozen_string_literal: true

require 'securerandom'
require 'real_world/comment/spec_factory_shared_context'

RSpec.shared_examples 'a comment repository' do
  include_context 'comment factory'

  before { subject.clear }

  context 'when there are no comments stored' do
    it '#create' do
      expect { subject.create(some_comment) }.not_to raise_error
    end

    it '#read_by_id' do
      expect(subject.read_by_id(id)).to be(nil)
    end
  end

  context 'when there is a comment' do
    before { subject.create(some_comment) }

    describe '#create' do
      context 'when the id is duplicated' do
        it 'raises an exception' do
          expect {
            subject.create(some_comment)
          }.to raise_error(StandardError)
        end
      end
    end

    it '#read_by_id' do
      expect(subject.read_by_id(id)).to eq(some_comment)
    end

    it '#delete' do
      expect { subject.delete(some_comment) }.not_to raise_error
      expect(subject.read_by_id(id)).to be(nil)
    end
  end

  context 'when there are several comments' do
    let(:comments_to_a_certain_article) do
      (1..4).map do |i|
        some_comment.merge(
          id: SecureRandom.uuid,
          article_id: article_id,
          created_at: i,
          updated_at: i + 0.5,
        )
      end
    end

    let(:comments_to_a_different_article) do
      [
        some_comment.merge(
          id: SecureRandom.uuid,
          article_id: SecureRandom.uuid,
        ),
      ]
    end

    before do
      (comments_to_a_certain_article + \
        comments_to_a_different_article).each do |comment|
        subject.create(comment)
      end
    end

    describe '#list' do
      it 'returns a list of comments ordered by creation time' do
        list, = subject.list(article_id: article_id)
        expect(list).to eq(comments_to_a_certain_article.reverse)
      end

      it 'supports pagination' do
        list, pagination_info = subject.list(
          article_id: article_id,
          limit: 30,
          offset: 5,
        )

        expect(list).to be_empty
        expect(pagination_info).to include(limit: 30, offset: 5, total_elements: 4)
      end
    end
  end
end
