# frozen_string_literal: true

require 'securerandom'

RSpec.shared_context 'follow factory' do
  let(:follower_id) { SecureRandom.uuid }
  let(:followed_id) { SecureRandom.uuid }
end
