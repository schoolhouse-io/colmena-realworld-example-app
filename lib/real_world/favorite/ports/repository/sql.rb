# frozen_string_literal: true

require 'real_world/sequel'

module RealWorld
  module Favorite
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @favorites, @counters = create_collections?(db)
            @unsafe = unsafe
          end

          def transaction
            @db.transaction { yield }
          end

          def favorited?(article_ids:, user_id:)
            index = Hash[@favorites.where(article_id: article_ids, user_id: user_id).map do |favorite|
              [favorite.fetch(:article_id), true]
            end]

            article_ids.each do |article_id|
              index[article_id] ||= false
            end

            index
          end

          def create(article_id:, user_id:)
            @favorites.insert(article_id: article_id, user_id: user_id)

            counter = @counters[article_id: article_id]

            if counter
              @counters.where(article_id: article_id).update(
                count: counter.fetch(:count) + 1,
              )
            else
              @counters.insert(article_id: article_id, count: 0)
            end
          end

          def delete(article_id:, user_id:)
            @favorites.where(article_id: article_id, user_id: user_id).delete

            counter = @counters[article_id: article_id]

            if counter.fetch(:count) <= 1
              @counters.where(article_id: article_id).delete
            else
              @counters.where(article_id: article_id).update(
                count: counter.fetch(:count) - 1,
              )
            end
          end

          def count(article_ids:)
            index = Hash[@counters.where(article_id: article_ids).map do |counter|
              [counter.fetch(:article_id), counter.fetch(:count)]
            end]

            article_ids.each do |article_id|
              index[article_id] ||= 0
            end

            index
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @favorites.delete
          end

          private

          def create_collections?(db)
            db.create_table?(:favorites) do
              uuid :article_id
              uuid :user_id
              primary_key [:article_id, :user_id]
            end

            db.create_table?(:favorite_counters) do
              uuid :article_id
              Integer :count

              primary_key [:article_id]
            end

            return db[:favorites], db[:favorite_counters]
          end
        end
      end
    end
  end
end
