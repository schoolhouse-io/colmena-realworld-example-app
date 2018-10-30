# frozen_string_literal: true

require 'securerandom'

RSpec.shared_context 'favorite factory' do
  let(:article_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
end
