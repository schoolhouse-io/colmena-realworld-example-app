# frozen_string_literal: true

require 'colmena/event'
require 'real_world/feed/ports/spec_shared_context'
require 'real_world/feed/listeners/follower_tracker'
require 'securerandom'

describe RealWorld::Feed::Listeners::FollowerTracker do
  include_context 'feed ports'

  let(:listener) { described_class.new(ports) }

  let(:some_article) do
    {
      id: SecureRandom.uuid,
      author_id: some_author,
      created_at: 1.1,
    }
  end
  let(:some_user) { SecureRandom.uuid }
  let(:some_author) { SecureRandom.uuid }

  context 'when it receives a :user_was_followed event' do
    it 'creates an entry for each of the articles by that author' do
      expect(router).to(
        receive(:query).and_return(
          ->(*) do
            {
              data: [some_article],
              pagination: { total_elements: 2 },
            }
          end,
        ),
      )

      listener.call(
        Colmena::Event.call(
          :user_was_followed,
          follower_id: some_user,
          followed_id: some_author,
        ),
      )

      expect(repository.list(user_id: some_user).first).to(
        eq([some_article.fetch(:id)]),
      )
    end
  end

  context 'when it receives a :user_was_unfollowed event' do
    before do
      2.times do
        repository.create(
          user_id: some_user,
          article_id: SecureRandom.uuid,
          article_author_id: some_author,
          article_created_at: 1.1,
        )
      end
    end

    it 'creates an entry for each of the articles by that author' do
      listener.call(
        Colmena::Event.call(
          :user_was_unfollowed,
          follower_id: some_user,
          followed_id: some_author,
        ),
      )

      expect(repository.list(user_id: some_user).first).to be_empty
    end
  end
end
