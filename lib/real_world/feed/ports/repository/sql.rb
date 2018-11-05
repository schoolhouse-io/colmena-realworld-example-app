# frozen_string_literal: true

require 'sequel'
require 'real_world/sequel'

module RealWorld
  module Feed
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @feed = create_feed_collection?(db)
            @unsafe = unsafe
          end

          def create(user_id:, article_id:, article_created_at:, article_author_id:)
            @feed.insert(
              user_id: user_id,
              article_id: article_id,
              article_created_at: article_created_at,
              article_author_id: article_author_id,
            )
          end

          def list(user_id:, limit: nil, offset: nil)
            feed =
              @feed
              .where(user_id: user_id)
              .order(::Sequel.desc(:article_created_at))

            feed, pagination = Sequel.with_pagination_info(feed, limit || 100, offset || 0)
            [feed.map { |item| item.fetch(:article_id) }, pagination]
          end

          def delete_by_article_author(user_id:, article_author_id:)
            @feed.where(
              user_id: user_id,
              article_author_id: article_author_id,
            ).delete
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @feed.delete
          end

          private

          def create_feed_collection?(db)
            db.create_table?(:feed) do
              uuid :article_id
              uuid :user_id, null: false, index: true
              uuid :article_author_id, null: false, index: true
              Float :article_created_at, null: false

              primary_key [:article_id, :user_id]
            end

            db[:feed]
          end
        end
      end
    end
  end
end
