# frozen_string_literal: true

require 'securerandom'

RSpec.shared_context 'article factory' do
  let(:id) { SecureRandom.uuid }
  let(:title) { 'Some title' }
  let(:slug) { 'some-title' }
  let(:description) { 'Some description' }
  let(:body) { 'This is the body' }
  let(:tags) { ['tag1', 'tag2', 'tag3'] }
  let(:favorites_count) { 0 }
  let(:author_id) { SecureRandom.uuid }

  let(:some_article) do
    {
      id: id,
      title: title,
      slug: slug,
      description: description,
      body: body,
      tags: tags,
      author_id: author_id,
      favorites_count: favorites_count,
      created_at: Time.now.to_f,
      updated_at: Time.now.to_f,
    }
  end
end
