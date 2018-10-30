# frozen_string_literal: true

require 'sequel'
require 'json'
require 'real_world/sequel'

module RealWorld
  module Article
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @articles = create_articles_collection?(db)
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

          def list(limit: nil, offset: nil)
            articles, pagination = Sequel.with_pagination_info(@articles, limit || 100, offset || 0)
            [articles.map(&DESERIALIZE), pagination]
          end

          def create(article)
            @articles.insert(SERIALIZE.call(article))
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @articles.delete
          end

          private

          def create_articles_collection?(db)
            db.create_table?(:articles) do
              uuid :id, primary_key: true

              String :title, size: 100, null: false
              String :slug, size: 60, null: false, unique: true
              String :description, size: 200, null: false, unique: true
              String :body, null: false
              jsonb :tags, null: false
              uuid :author_id, null: false
              Float :created_at, null: false
              Float :updated_at, null: false
            end

            db[:articles]
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
