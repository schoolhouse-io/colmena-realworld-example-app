# frozen_string_literal: true

require 'real_world/sequel'

module RealWorld
  module Follow
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @follows = create_collection?(db)
            @unsafe = unsafe
          end

          def transaction
            @db.transaction { yield }
          end

          def read(follower_id:, followed_id:)
            @follows[follower_id: follower_id, followed_id: followed_id]
          end

          def create(follower_id:, followed_id:)
            @follows.insert(follower_id: follower_id, followed_id: followed_id)
          end

          def delete(follower_id:, followed_id:)
            @follows.where(follower_id: follower_id, followed_id: followed_id).delete
          end

          def list_followed(by:, limit: nil, offset: nil)
            query = @follows.where(follower_id: by)

            Sequel.with_pagination_info(query, limit || 100, offset || 0)
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @follows.delete
          end

          private

          def create_collection?(db)
            db.create_table?(:following_relationships) do
              uuid :follower_id
              uuid :followed_id
              primary_key [:follower_id, :followed_id]
            end

            db[:following_relationships]
          end
        end
      end
    end
  end
end
