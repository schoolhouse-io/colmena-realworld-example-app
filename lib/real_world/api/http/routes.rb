# frozen_string_literal: true

module RealWorld
  module Api
    module Http
      ROUTES = ->(*) do
        require 'real_world/api/http/endpoints/users'
        post '/users', to: Endpoints::Users::Register
        post '/users/login', to: Endpoints::Users::Login
        get  '/user', to: Endpoints::Users::GetCurrent
        put  '/user', to: Endpoints::Users::UpdateCurrent

        require 'real_world/api/http/endpoints/profiles'
        get    '/profiles/:username',        to: Endpoints::Profiles::Get
        post   '/profiles/:username/follow', to: Endpoints::Profiles::Follow
        delete '/profiles/:username/follow', to: Endpoints::Profiles::Unfollow

        require 'real_world/api/http/endpoints/articles'
        get    '/articles', to: Endpoints::Articles::List
        post   '/articles', to: Endpoints::Articles::Create
        get    '/articles/feed', to: Endpoints::Articles::Feed
        get    '/articles/:slug', to: Endpoints::Articles::Get
        put    '/articles/:slug', to: Endpoints::Articles::Update
        post   '/articles/:slug/favorite', to: Endpoints::Articles::Favorite
        delete '/articles/:slug/favorite', to: Endpoints::Articles::Unfavorite

        require 'real_world/api/http/endpoints/comments'
        get    '/articles/:slug/comments', to: Endpoints::Comments::List
        post   '/articles/:slug/comments', to: Endpoints::Comments::Create
        delete '/articles/:slug/comments/:id', to: Endpoints::Comments::Create

        require 'real_world/api/http/endpoints/tags'
        get '/tags', to: Endpoints::Tags::List
      end
    end
  end
end
