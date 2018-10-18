# frozen_string_literal: true

require 'colmena/cell'
require 'real_world/follow/commands/follow'
require 'real_world/follow/commands/unfollow'
require 'real_world/follow/queries/list_followed'

module RealWorld
  module Follow
    class Cell
      include Colmena::Cell

      register_port :repository
      register_command Commands::Follow
      register_command Commands::Unfollow
      register_query Queries::ListFollowed
    end
  end
end
