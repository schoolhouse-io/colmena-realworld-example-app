# frozen_string_literal: true

require 'real_world/article/domain'

describe RealWorld::Article::Domain do
  let(:title) { 'Some title' }
  let(:description) { 'Some description' }
  let(:body) { 'This is the body' }
  let(:tags) { ['tag1', 'tag2'] }
  let(:author_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  let(:article) do
    described_class.create(
      title,
      description,
      body,
      ['tag1', 'tag2'],
      author_id,
    ).fetch(:data)
  end

  describe '.create' do
    subject { described_class.create(title, description, body, tags, author_id) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(
              id: be_a(String),
              title: title,
              slug: match(/^some-title-(\w|[0-9])+$/),
              description: description,
              body: body,
              tags: tags,
              author_id: author_id,
            ),
            events: [:article_created, :article_tag_added, :article_tag_added],
          ),
        )
      }
    end

    context 'when some tags are duplicated' do
      let(:tags) { ['tag1', 'tag2', 'tag1'] }

      it {
        is_expected.to(
          succeed(
            data: include(tags: ['tag1', 'tag2']),
            events: [:article_created, :article_tag_added, :article_tag_added],
          ),
        )
      }
    end

    [nil, 1, '', 'a', 'a' * 200].each do |invalid_title|
      context "when the title is '#{invalid_title}'" do
        let(:title) { invalid_title }
        it { is_expected.to fail_with_errors(:title_is_invalid) }
      end
    end

    [nil, 1, '', 'x', 'long' * 60].each do |invalid_description|
      context "when the description is '#{invalid_description}'" do
        let(:description) { invalid_description }
        it { is_expected.to fail_with_errors(:description_is_invalid) }
      end
    end

    [nil, 1, ''].each do |invalid_body|
      context "when the body is '#{invalid_body}'" do
        let(:body) { invalid_body }
        it { is_expected.to fail_with_errors(:body_is_invalid) }
      end
    end

    [nil, 1, [], (1..20).map { |i| "tag#{i}" }].each do |invalid_tags|
      context "when the tags are '#{invalid_tags}'" do
        let(:tags) { invalid_tags }
        it { is_expected.to fail_with_errors(:tags_are_invalid) }
      end
    end
  end

  describe '.update' do
    subject { described_class.update(article, title, description, body, tags) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(
              id: be_a(String),
              title: title,
              slug: match(/^some-title-(\w|[0-9])+$/),
              description: description,
              body: body,
              tags: tags,
              author_id: author_id,
            ),
            events: [:article_updated],
          ),
        )
      }
    end

    context 'when tags change' do
      let(:tags) { ['tag1', 'tag3'] }

      it {
        is_expected.to(
          succeed(
            data: include(tags: ['tag1', 'tag3']),
            events: [:article_updated, :article_tag_added, :article_tag_deleted],
          ),
        )
      }
    end

    [nil, 1, '', 'a', 'a' * 200].each do |invalid_title|
      context "when the title is '#{invalid_title}'" do
        let(:title) { invalid_title }
        it { is_expected.to fail_with_errors(:title_is_invalid) }
      end
    end

    [nil, 1, '', 'x', 'long' * 60].each do |invalid_description|
      context "when the description is '#{invalid_description}'" do
        let(:description) { invalid_description }
        it { is_expected.to fail_with_errors(:description_is_invalid) }
      end
    end

    [nil, 1, ''].each do |invalid_body|
      context "when the body is '#{invalid_body}'" do
        let(:body) { invalid_body }
        it { is_expected.to fail_with_errors(:body_is_invalid) }
      end
    end

    [nil, 1, [], (1..20).map { |i| "tag#{i}" }].each do |invalid_tags|
      context "when the tags are '#{invalid_tags}'" do
        let(:tags) { invalid_tags }
        it { is_expected.to fail_with_errors(:tags_are_invalid) }
      end
    end
  end

  describe '.favorite' do
    subject { described_class.favorite(article, user_id) }

    it {
      is_expected.to(
        succeed(
          data: include(favorites_count: 1),
          events: [:article_favorited],
        ),
      )
    }
  end

  describe '.unfavorite' do
    subject { described_class.unfavorite(article.merge(favorites_count: 1), user_id) }

    it {
      is_expected.to(
        succeed(
          data: include(favorites_count: 0),
          events: [:article_unfavorited],
        ),
      )
    }
  end
end
