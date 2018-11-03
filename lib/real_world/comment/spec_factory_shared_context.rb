# frozen_string_literal: true

require 'securerandom'

RSpec.shared_context 'comment factory' do
  let(:id) { SecureRandom.uuid }
  let(:body) { 'This is the body' }
  let(:article_id) { SecureRandom.uuid }
  let(:author_id) { SecureRandom.uuid }

  let(:some_comment) do
    {
      id: id,
      body: body,
      author_id: author_id,
      article_id: article_id,
      created_at: Time.now.to_f,
      updated_at: Time.now.to_f,
    }
  end
end
