# frozen_string_literal: true

require 'securerandom'
require 'real_world/follow/spec_factory_shared_context'

RSpec.shared_examples 'a repository for following relationships' do
  include_context 'follow factory'

  before { subject.clear }

  context 'when there are no following relationships stored' do
    it '#create' do
      expect { subject.create(follower_id: follower_id, followed_id: followed_id) }.not_to raise_error
    end

    it '#read' do
      expect(subject.read(follower_id: follower_id, followed_id: followed_id)).to be(nil)
    end

    it '#list_followed' do
      resp, = subject.list_followed(by: follower_id)
      expect(resp).to be_empty
    end

    it '#list_followers' do
      resp, = subject.list_followers(of: followed_id)
      expect(resp).to be_empty
    end
  end

  context 'when there are a few following relationships stored' do
    let(:relationships) do
      Array.new(3) { { follower_id: follower_id, followed_id: SecureRandom.uuid } } +
        Array.new(3) { { follower_id: SecureRandom.uuid, followed_id: followed_id } }
    end

    before { relationships.each { |r| subject.create(r) } }

    it '#create' do
      expect { subject.create(relationships.first) }.to raise_error(StandardError)
    end

    it '#delete' do
      subject.delete(relationships.last)
      expect(subject.read(relationships.last)).to be(nil)
    end

    it '#read' do
      expect(subject.read(relationships.first)).to eq(relationships.first)
    end

    it '#list_followed' do
      resp, pagination_info = subject.list_followed(by: follower_id, limit: 100, offset: 1)
      expect(resp.size).to eq(2)
      expect(pagination_info).to include(limit: 100, offset: 1, total_elements: 3)
    end

    it '#list_followers' do
      resp, pagination_info = subject.list_followers(of: followed_id, limit: 100, offset: 1)
      expect(resp.size).to eq(2)
      expect(pagination_info).to include(limit: 100, offset: 1, total_elements: 3)
    end
  end
end
