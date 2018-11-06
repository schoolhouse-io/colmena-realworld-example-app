# frozen_string_literal: true

require 'real_world/feed/ports/spec_shared_context'
require 'real_world/feed/queries/list_articles_feed'
require 'securerandom'

describe RealWorld::Feed::Queries::ListArticlesFeed do
  include_context 'feed ports'

  let(:user_id) { SecureRandom.uuid }
  let(:limit) { 40 }
  let(:offset) { 2 }
  let(:query) { described_class.new(ports) }

  subject { query.call(user_id: user_id, limit: limit, offset: offset) }

  it 'returns the list from the repository and the pagination info' do
    expect(subject).to(
      include(
        data: be_an(Array),
        pagination: include(:limit, :offset, :total_elements),
      ),
    )
  end
end
