# frozen_string_literal: true

require 'sequel'

module RealWorld
  module Auth
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @credentials = create_credentials_collection?(db)
            @unsafe = unsafe
          end

          def read_by_user_id(user_id)
            @credentials[user_id: user_id]
          end

          def create(user_id:, password:, salt:)
            @credentials.insert(user_id: user_id, password: password, salt: salt)
          end

          def delete(user_id)
            @credentials.where(user_id: user_id).delete
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @credentials.delete
          end

          private

          def create_credentials_collection?(db)
            db.create_table?(:auth_credentials) do
              primary_key :id

              uuid :user_id, null: false, unique: true
              String :password, size: 200, null: false
              String :salt, size: 10, null: false
            end

            db[:auth_credentials]
          end
        end
      end
    end
  end
end
