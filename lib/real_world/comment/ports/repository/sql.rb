# frozen_string_literal: true

require 'sequel'
require 'json'
require 'real_world/sequel'
require 'real_world/support/hash'

module RealWorld
  module Comment
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @comments = create_comments_collection?(db)
            @unsafe = unsafe
          end

          def transaction
            @db.transaction { yield }
          end

          def read_by_id(id)
            @comments[id: id]
          end

          def list(article_id:, limit: nil, offset: nil)
            query =
              @comments
              .where(article_id: article_id)
              .order(::Sequel.desc(:created_at))

            Sequel.with_pagination_info(query, limit || 100, offset || 0)
          end

          def create(comment)
            @comments.insert(comment)
          end

          def delete(comment)
            @comments.where(id: comment.fetch(:id)).delete
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @comments.delete
          end

          private

          def create_comments_collection?(db)
            db.create_table?(:comments) do
              uuid :id, primary_key: true

              String :body, null: false
              uuid :article_id, null: false, index: true
              uuid :author_id, null: false
              Float :created_at, null: false
              Float :updated_at, null: false
            end

            db[:comments]
          end
        end
      end
    end
  end
end
