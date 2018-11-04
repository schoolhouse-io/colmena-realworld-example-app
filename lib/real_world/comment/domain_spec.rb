# frozen_string_literal: true

require 'real_world/comment/domain'
require 'real_world/comment/ports/spec_shared_context'

describe RealWorld::Comment::Domain do
  include_context 'comment factory'

  describe '.create' do
    subject { described_class.create(body, article_id, author_id) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(
              id: be_a(String),
              body: body,
              article_id: article_id,
              author_id: author_id,
              created_at: be_a(Float),
              updated_at: be_a(Float),
            ),
            events: [:comment_created],
          ),
        )
      }
    end

    [nil, 1, ''].each do |invalid_body|
      context "when the body is '#{invalid_body}'" do
        let(:body) { invalid_body }
        it { is_expected.to fail_with_errors(:body_is_invalid) }
      end
    end

    [nil, 1, '', 'not a uuid'].each do |invalid_article_id|
      context "when the article_id is '#{invalid_article_id}'" do
        let(:article_id) { invalid_article_id }
        it { is_expected.to fail_with_errors(:article_id_is_invalid) }
      end
    end

    [nil, 1, '', 'not a uuid'].each do |invalid_author_id|
      context "when the author_id is '#{invalid_author_id}'" do
        let(:author_id) { invalid_author_id }
        it { is_expected.to fail_with_errors(:author_id_is_invalid) }
      end
    end
  end

  describe '.delete' do
    subject { described_class.delete(comment_to_delete) }

    context 'when the comment exists' do
      let(:comment_to_delete) { some_comment }

      it {
        is_expected.to(
          succeed(
            data: be(nil),
            events: [:comment_deleted],
          ),
        )
      }
    end

    context 'when the comment does not exist' do
      let(:comment_to_delete) { nil }

      it { is_expected.to fail_with_errors(:comment_does_not_exist) }
    end
  end
end
