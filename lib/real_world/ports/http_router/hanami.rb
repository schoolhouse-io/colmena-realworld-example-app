# frozen_string_literal: true

require 'hanami-router'
require 'json'

module RealWorld
  module Ports
    module HTTPRouter
      class Hanami
        def initialize(cell_router, routes_config)
          @router = ::Hanami::Router.new
          @cell_router = cell_router

          instance_eval(&routes_config)
        end

        def call(env, serialize: true)
          status, headers, body = @router.call(env)

          body = body.map(&:to_json) if serialize &&
                                        headers['Content-Type'] == 'application/json' &&
                                        body.respond_to?(:map)

          [status, headers, body]
        end

        private

        def get(uri, to:, **options)
          @router.get uri, to: endpoint(to), **options
        end

        def post(uri, to:, **options)
          @router.post uri, to: endpoint(to), **options
        end

        def patch(uri, to:, **options)
          @router.patch uri, to: endpoint(to), **options
        end

        def put(uri, to:, **options)
          @router.put uri, to: endpoint(to), **options
        end

        def delete(uri, to:, **options)
          @router.delete uri, to: endpoint(to), **options
        end

        def options(uri, to:, **options)
          @router.options uri, to: endpoint(to), **options
        end

        def endpoint(to)
          to.respond_to?(:new) ? to.new(@cell_router) : to
        end
      end
    end
  end
end
