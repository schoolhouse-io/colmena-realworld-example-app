# frozen_string_literal: true

module RealWorld
  module Http
    module Endpoint
      module ClassMethods
        def mapper
          @mapper
        end

        def custom_mapper(mapper)
          @mapper = mapper
        end

        def handler
          @handler
        end

        def custom_handler(handler)
          @handler = handler
        end

        def error_handler
          @error_handler
        end

        def custom_error_handler(error_handler)
          @error_handler = error_handler
        end

        def target
          @target
        end

        def command(name)
          @target = [:command, name]
        end

        def query(name)
          @target = [:query, name]
        end
      end

      def self.included(klass)
        klass.extend ClassMethods
      end

      def initialize(router, _options = {})
        @router = router
      end

      def call(env)
        type, name = self.class.target
        target = type == :query ? @router.query(name) : @router.command(name)
        params = target_parameters(target)

        result = if params.empty?
                   target.call
                 else
                   params, error = self.class.mapper.call(params, env)
                   return self.class.error_handler.call([error]) if error

                   target.call(params)
                 end

        if result.fetch(:errors).empty?
          self.class.handler.call(result, env)
        else
          self.class.error_handler.call(result.fetch(:errors))
        end
      end

      private

      PARAM_FORMAT = ->(param_def) do
        type, name, = param_def

        {
          name: name.to_s,
          required: type == :keyreq,
        }
      end

      def target_parameters(target)
        target.method(:call).parameters.map(&PARAM_FORMAT)
      end
    end
  end
end
