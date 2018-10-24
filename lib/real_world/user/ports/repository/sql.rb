# frozen_string_literal: true

require 'sequel'

module RealWorld
  module User
    module Ports
      module Repository
        class SQL
          def initialize(db, unsafe: false)
            @db = db
            @users = create_users_collection?(db)
            @unsafe = unsafe
          end

          def transaction
            @db.transaction { yield }
          end

          def read_by_id(id)
            @users[id: id]
          end

          def read_by_email(email)
            @users[email: email]
          end

          def read_by_username(username)
            @users[username: username]
          end

          def create(id:, email:, username:, bio:, image:)
            @users.insert(id: id, email: email, username: username, bio: bio, image: image)
          end

          def update(id:, email:, username:, bio:, image:)
            @users.where(id: id).update(email: email, username: username, bio: bio, image: image)
          end

          def clear
            raise 'Cannot .clear unless unsafe mode is on' unless @unsafe

            @users.delete
          end

          private

          def create_users_collection?(db)
            db.create_table?(:users) do
              uuid :id, primary_key: true

              String :email, size: 200, null: false, unique: true
              String :username, size: 100, null: false, unique: true
              String :bio, size: 500, null: false
              String :image, size: 500, null: false
            end

            db[:users]
          end
        end
      end
    end
  end
end
