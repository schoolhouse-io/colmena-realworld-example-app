# frozen_string_literal: true

require 'securerandom'

RSpec.shared_examples 'a feed repository' do
  before { subject.clear }

  let(:some_article) { SecureRandom.uuid }
  let(:some_user) { SecureRandom.uuid }

  context 'when there is no article in the feed' do
    it '#create' do
      subject.create(user_id: some_user, article_id: some_article)
      expect(subject.list(user_id: some_user).first).to eq([some_article])
    end

    it '#list' do
      list, = subject.list(user_id: some_user)
      expect(list).to be_empty
    end
  end

  context 'when there is an article in the feed' do
    before do
      subject.create(user_id: some_user, article_id: some_article)
    end

    it '#create' do
      expect {
        subject.create(user_id: some_user, article_id: some_article)
      }.to raise_error(StandardError)
    end

    it '#list' do
      list, = subject.list(user_id: some_user)
      expect(list).to eq([some_article])
    end

    it '#list with pagination' do
      list, pagination_info = subject.list(user_id: some_user, limit: 30, offset: 2)
      expect(list).to be_empty
      expect(pagination_info).to include(limit: 30, offset: 2, total_elements: 1)
    end
  end
end
