# frozen_string_literal: true

require 'sequel'
require 'json'
require 'real_world/sequel'
require 'real_world/support/hash'

module RealWorld
  module Article
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @articles = create_articles_collection?(db)
            @favorites = create_favorites_collection?(db)
            @unsafe = unsafe
          end

          def transaction
            @db.transaction { yield }
          end

          def read_by_id(id)
            article = @articles[id: id]
            return unless article

            DESERIALIZE.call(article)
          end

          def read_by_slug(slug)
            article = @articles[slug: slug]
            return unless article

            DESERIALIZE.call(article)
          end

          def list(author_id: nil, tag: nil, favorited_by: nil, limit: nil, offset: nil)
            articles = @articles
            articles = articles.where(author_id: author_id) if author_id
            articles = with_tag(articles, tag) if tag
            articles = articles.where(id: @favorites.where(user_id: favorited_by).select(:article_id)) if favorited_by
            articles = articles.order(::Sequel.desc(:created_at))

            articles, pagination = Sequel.with_pagination_info(articles, limit || 100, offset || 0)
            [articles.map(&DESERIALIZE), pagination]
          end

          def create(article)
            @articles.insert(SERIALIZE.call(article))
          end

          def update(article)
            @articles.where(id: article.fetch(:id)).update(SERIALIZE.call(article))
          end

          def favorite(article, user_id)
            @favorites.insert(article_id: article.fetch(:id), user_id: user_id)
            update(article)
          end

          def unfavorite(article, user_id)
            @favorites.where(article_id: article.fetch(:id), user_id: user_id).delete
            update(article)
          end

          def favorited?(article_ids:, user_id:)
            favorites = Support::Hash.index_by(@favorites.where(article_id: article_ids, user_id: user_id), :article_id)

            Hash[article_ids.map do |article_id|
              [article_id, favorites[article_id] && true || false]
            end]
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @articles.delete
            @favorites.delete
          end

          private

          def with_tag(articles, tag)
            # See json_each() docs here: https://www.sqlite.org/json1.html#jex
            articles_with_tag = @db.fetch('SELECT DISTINCT articles.id '\
                                          'FROM articles, json_each(articles.tags) '\
                                          'WHERE json_each.value = ?',
                                          tag)

            articles.where(id: articles_with_tag)
          end

          def create_articles_collection?(db)
            db.create_table?(:articles) do
              uuid :id, primary_key: true

              String :title, size: 100, null: false
              String :slug, size: 60, null: false, unique: true
              String :description, size: 200, null: false
              String :body, null: false
              jsonb :tags, null: false
              uuid :author_id, null: false, index: true
              Integer :favorites_count, null: false
              Float :created_at, null: false
              Float :updated_at, null: false
            end

            db[:articles]
          end

          def create_favorites_collection?(db)
            db.create_table?(:article_favorites) do
              uuid :article_id
              uuid :user_id

              primary_key [:article_id, :user_id]
            end

            db[:article_favorites]
          end

          SERIALIZE = ->(article) do
            article.merge(tags: article.fetch(:tags).to_json)
          end

          DESERIALIZE = ->(article) do
            article.merge(tags: JSON.parse(article.fetch(:tags)))
          end
        end
      end
    end
  end
end
