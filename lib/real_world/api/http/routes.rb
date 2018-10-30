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
        get    '/articles/:slug', to: Endpoints::Articles::Get
        post   '/articles/:slug/favorite', to: Endpoints::Articles::Favorite
        delete '/articles/:slug/favorite', to: Endpoints::Articles::Unfavorite

        require 'real_world/api/http/endpoints/tags'
        get '/tags', to: Endpoints::Tags::List
      end
    end
  end
end
