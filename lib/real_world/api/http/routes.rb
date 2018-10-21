# frozen_string_literal: true

require 'real_world/api/http/endpoints/users'

module RealWorld
  module Api
    module Http
      ROUTES = ->(*) do
        post '/users', to: Endpoints::Users::Register
        post '/users/login', to: Endpoints::Users::Login

        get  '/user', to: Endpoints::Users::GetCurrent
        put  '/user', to: Endpoints::Users::UpdateCurrent
      end
    end
  end
end
