# frozen_string_literal: true

require 'colmena/cell'
require 'real_world/api/http/routes'
require 'real_world/ports/http_router/hanami'

module RealWorld
  module Api
    class Cell
      include Colmena::Cell

      register_port :router
      register_port :tokens

      # USERS
      require 'real_world/api/queries/api_get_current_user'
      register_query Queries::ApiGetCurrentUser

      require 'real_world/api/commands/api_register'
      register_command Commands::ApiRegister

      require 'real_world/api/commands/api_login'
      register_command Commands::ApiLogin

      require 'real_world/api/commands/api_update_current_user'
      register_command Commands::ApiUpdateCurrentUser

      # PROFILES
      require 'real_world/api/queries/api_get_profile'
      register_query Queries::ApiGetProfile

      require 'real_world/api/queries/api_index_profiles'
      register_query Queries::ApiIndexProfiles

      require 'real_world/api/commands/api_follow_profile'
      register_command Commands::ApiFollowProfile

      require 'real_world/api/commands/api_unfollow_profile'
      register_command Commands::ApiUnfollowProfile

      # ARTICLES
      require 'real_world/api/queries/api_list_articles'
      register_query Queries::ApiListArticles

      require 'real_world/api/queries/api_list_articles_feed'
      register_query Queries::ApiListArticlesFeed

      require 'real_world/api/queries/api_get_article'
      register_query Queries::ApiGetArticle

      require 'real_world/api/commands/api_create_article'
      register_command Commands::ApiCreateArticle

      require 'real_world/api/commands/api_update_article'
      register_command Commands::ApiUpdateArticle

      require 'real_world/api/commands/api_favorite_article'
      register_command Commands::ApiFavoriteArticle

      require 'real_world/api/commands/api_unfavorite_article'
      register_command Commands::ApiUnfavoriteArticle

      # COMMENTS
      require 'real_world/api/queries/api_list_comments'
      register_query Queries::ApiListComments

      require 'real_world/api/commands/api_create_comment'
      register_command Commands::ApiCreateComment

      require 'real_world/api/commands/api_delete_comment'
      register_command Commands::ApiDeleteComment

      # TAGS
      require 'real_world/api/queries/api_list_tags'
      register_query Queries::ApiListTags

      def call(env)
        @http_router ||= RealWorld::Ports::HttpRouter::Hanami.new(
          port(:router),
          Http::ROUTES,
        )

        @http_router.call(env)
      end
    end
  end
end
