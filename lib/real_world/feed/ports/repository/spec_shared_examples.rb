# frozen_string_literal: true

require 'securerandom'

RSpec.shared_examples 'a feed repository' do
  before { subject.clear }

  let(:some_article) { SecureRandom.uuid }
  let(:some_user) { SecureRandom.uuid }
  let(:some_author) { SecureRandom.uuid }

  context 'when there is no article in the feed' do
    it '#create' do
      subject.create(
        user_id: some_user,
        article_id: some_article,
        article_created_at: 1.1,
        article_author_id: some_author,
      )
      expect(subject.list(user_id: some_user).first).to eq([some_article])
    end

    it '#list' do
      list, = subject.list(user_id: some_user)
      expect(list).to be_empty
    end
  end

  context 'when there is an article in the feed' do
    before do
      subject.create(
        user_id: some_user,
        article_id: some_article,
        article_created_at: 1.1,
        article_author_id: some_author,
      )
    end

    it '#create' do
      expect {
        subject.create(
          user_id: some_user,
          article_id: some_article,
          article_created_at: 1.1,
          article_author_id: some_author,
        )
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

  context 'when there are several article in a user\'s feed' do
    let(:user_feed) do
      (1..3).map do |i|
        {
          user_id: some_user,
          article_id: SecureRandom.uuid,
          article_created_at: i,
          article_author_id: some_author,
        }
      end
    end

    before { user_feed.each { |item| subject.create(item) } }

    it '#list orders by creation date' do
      list, = subject.list(user_id: some_user)
      expect(list).to eq(user_feed.reverse.map { |item| item.fetch(:article_id) })
    end
  end

  context 'when there are several article in a user\'s feed' do
    let(:article_author_id) { SecureRandom.uuid }
    before do
      # User feed (articles by various authors)
      [
        article_author_id,
        SecureRandom.uuid,
        article_author_id,
      ].map do |author_id|
        subject.create(
          user_id: some_user,
          article_id: SecureRandom.uuid,
          article_created_at: 1.1,
          article_author_id: author_id,
        )
      end

      # Same article author; different user
      subject.create(
        user_id: SecureRandom.uuid,
        article_id: SecureRandom.uuid,
        article_created_at: 1.1,
        article_author_id: article_author_id,
      )
    end

    it '#delete_by_article_author' do
      subject.delete_by_article_author(
        user_id: some_user,
        article_author_id: article_author_id,
      )

      list, = subject.list(user_id: some_user)
      expect(list.size).to eq(1)
    end
  end
end
