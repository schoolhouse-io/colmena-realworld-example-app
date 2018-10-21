# frozen_string_literal: true

require 'real_world/api/http/endpoints/users'
require 'real_world/api/http/endpoints/profiles'

module RealWorld
  module Api
    module Http
      ROUTES = ->(*) do
        post '/users', to: Endpoints::Users::Register
        post '/users/login', to: Endpoints::Users::Login

        get  '/user', to: Endpoints::Users::GetCurrent
        put  '/user', to: Endpoints::Users::UpdateCurrent

        get    '/profiles/:username',        to: Endpoints::Profiles::Get
        post   '/profiles/:username/follow', to: Endpoints::Profiles::Follow
        delete '/profiles/:username/follow', to: Endpoints::Profiles::Unfollow
      end
    end
  end
end
