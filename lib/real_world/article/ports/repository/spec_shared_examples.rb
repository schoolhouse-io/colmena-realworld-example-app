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

    it '#read_by_slug' do
      expect(subject.read_by_slug(slug)).to eq(some_article)
    end
  end
end
