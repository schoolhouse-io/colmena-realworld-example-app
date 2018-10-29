# frozen_string_literal: true

require 'sequel'
require 'json'

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

            deserialize(article)
          end

          def read_by_slug(slug)
            article = @articles[slug: slug]
            return unless article

            deserialize(article)
          end

          def create(article)
            @articles.insert(serialize(article))
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

          def serialize(article)
            article.merge(tags: article.fetch(:tags).to_json)
          end

          def deserialize(article)
            article.merge(tags: JSON.parse(article.fetch(:tags)))
          end
        end
      end
    end
  end
end
