# frozen_string_literal: true

require 'securerandom'
require 'colmena/domain'
require 'real_world/comment/domain/validation'

module RealWorld
  module Comment
    module Domain
      extend Colmena::Domain

      events :comment_created,
             handler: ->(comment, event) { comment.merge(event.fetch(:data)) }

      events :comment_deleted,
             handler: ->(*) { nil }

      def self.create(body, article_id, author_id)
        capture_errors(
          Validation.body(body),
          Validation.article_id(article_id),
          Validation.author_id(author_id),
        ) do
          comment = {
            id: SecureRandom.uuid,
            body: body,
            author_id: author_id,
            article_id: article_id,
            created_at: Time.now.to_f,
            updated_at: Time.now.to_f,
          }

          response(
            comment,
            events: [event(:comment_created, comment)],
          )
        end
      end

      def self.delete(comment)
        return error_response(:comment_does_not_exist) unless comment

        response(nil, events: [event(:comment_deleted, comment)])
      end
    end
  end
end
