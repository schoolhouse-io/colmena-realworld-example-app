# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/transactions/materialize'
require 'real_world/comment/materializer'

module RealWorld
  module Comment
    class Cell
      include Colmena::Cell

      register_port :repository
      register_port :event_publisher
      register_port :logger

      TRANSACTION = Colmena::Transactions::Materialize[
        event_materializer: Materializer,
        event_stream: :comment_events,
      ]

      require 'real_world/comment/queries/read_comment_by_id'
      register_query Queries::ReadCommentById

      require 'real_world/comment/queries/list_comments'
      register_query Queries::ListComments

      require 'real_world/comment/commands/create_comment'
      register_command TRANSACTION[Commands::CreateComment]

      require 'real_world/comment/commands/delete_comment'
      register_command TRANSACTION[Commands::DeleteComment]
    end
  end
end
