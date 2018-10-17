# frozen_string_literal: true

require 'real_world/api/http/endpoints/users'

module RealWorld
  module Api
    module Http
      ROUTES = ->(*) do
        post '/users', to: Endpoints::Users::Register
      end
    end
  end
end
