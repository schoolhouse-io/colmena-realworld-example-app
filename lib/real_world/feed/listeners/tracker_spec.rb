# frozen_string_literal: true

require 'colmena/event'
require 'real_world/feed/ports/spec_shared_context'
require 'real_world/feed/listeners/tracker'
require 'securerandom'

describe RealWorld::Feed::Listeners::Tracker do
  include_context 'feed ports'

  let(:listener) { described_class.new(ports) }

  let(:some_article) { SecureRandom.uuid }
  let(:some_user) { SecureRandom.uuid }
  let(:some_follower) { SecureRandom.uuid }

  context 'when it receives an :article_created event' do
    it 'creates an entry for each of the followers of the author' do
      expect(router).to(
        receive(:query).and_return(
          ->(*) do
            {
              data: [some_follower],
              pagination: { total_elements: 1 },
            }
          end,
        ),
      )

      listener.call(Colmena::Event.call(:article_created,
                                        id: some_article,
                                        author_id: some_user))

      expect(repository.list(user_id: some_follower).first).to eq([some_article])
    end
  end
end
