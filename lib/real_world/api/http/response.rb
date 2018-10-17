# frozen_string_literal: true

module RealWorld
  module Api
    module Http
      module Response
        HEADERS = {
          'Content-Type' => 'application/json',
        }.freeze

        def self.call(status, body = {}, headers = {})
          headers = headers.merge('Access-Control-Expose-Headers' => headers.keys.join(', ')) unless headers.empty?

          [status, HEADERS.merge(headers), [body]]
        end
      end
    end
  end
end
