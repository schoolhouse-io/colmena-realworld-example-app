# frozen_string_literal: true

require 'securerandom'
require 'colmena/domain'
require 'real_world/article/domain/validation'

module RealWorld
  module Article
    module Domain
      extend Colmena::Domain

      events :article_created,
             handler: ->(article, event) { article.merge(event.fetch(:data)) }

      events :article_tag_added,
             handler: ->(article, event) do
                        article.merge(tags: article.fetch(:tags) + [event.dig(:data, :tag)])
                      end

      events :article_favorited,
             handler: ->(article, _event) do
                        article.merge(favorites_count: article.fetch(:favorites_count) + 1)
                      end

      events :article_unfavorited,
             handler: ->(article, _event) do
                        article.merge(favorites_count: article.fetch(:favorites_count) - 1)
                      end

      def self.create(title, description, body, tags, author_id)
        capture_errors(
          Validation.title(title),
          Validation.description(description),
          Validation.body(body),
          Validation.tags(tags),
          Validation.author_id(author_id),
        ) do
          article = {
            id: SecureRandom.uuid,
            title: title,
            slug: generate_slug(title),
            description: description,
            body: body,
            tags: [],
            author_id: author_id,
            favorites_count: 0,
            created_at: Time.now.to_f,
            updated_at: Time.now.to_f,
          }

          tag_events = Set.new(tags).map do |tag|
            event(:article_tag_added, id: article.fetch(:id), tag: tag)
          end

          events = [event(:article_created, article)] + tag_events

          response(apply({}, events), events: events)
        end
      end

      def self.favorite(article, user_id)
        capture_errors(
          Validation.user_id(user_id),
        ) do
          events = [event(:article_favorited, id: article.fetch(:id), user_id: user_id)]
          response(apply(article, events), events: events)
        end
      end

      def self.unfavorite(article, user_id)
        capture_errors(
          Validation.user_id(user_id),
        ) do
          events = [event(:article_unfavorited, id: article.fetch(:id), user_id: user_id)]
          response(apply(article, events), events: events)
        end
      end

      def self.generate_slug(title)
        title_slug = slugify(title, 50)
        random = random_string(4, [*'a'..'z', *'0'..'9'])
        "#{title_slug}-#{random}"
      end

      def self.slugify(str, limit)
        require 'stringex_lite'
        str.gsub(/[ÓÒ]/, 'o').to_url(limit: limit)
      end

      def self.random_string(length, allowed = [*'a'..'z'])
        Array.new(length) { allowed.sample }.join
      end
    end
  end
end
