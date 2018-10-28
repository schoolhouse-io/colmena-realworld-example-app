# frozen_string_literal: true

require 'sequel'
require 'real_world/sequel'

module RealWorld
  module Tag
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @tags = create_tags_collection?(db)
            @unsafe = unsafe
          end

          def read(name)
            @tags[name: name] || { count: 0 }
          end

          def increase(name)
            n_updated = @tags.where(name: name).update(count: ::Sequel.expr(:count) + 1)
            @tags.insert(name: name, count: 1) if n_updated.zero?
          end

          def decrease(name)
            tag = @tags[name: name]

            if tag
              if tag.fetch(:count) == 1
                @tags.where(name: name).delete
              else
                @tags.where(name: name).update(count: tag.fetch(:count) - 1)
              end
            end
          end

          def list(limit: nil, offset: nil)
            Sequel.with_pagination_info(@tags, limit || 100, offset || 0)
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @tags.delete
          end

          private

          def create_tags_collection?(db)
            db.create_table?(:tags) do
              String :name, size: 50, primary_key: true
              Integer :count, null: false
            end

            db[:tags]
          end
        end
      end
    end
  end
end
