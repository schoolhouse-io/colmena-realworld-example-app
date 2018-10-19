# frozen_string_literal: true

require 'colmena/port_injection'

module Colmena
  class Materializer
    include PortInjection

    class KnownError < RuntimeError
      attr_reader :type, :data

      def initialize(type, data = nil)
        @type = type
        @data = data
      end
    end
  end
end
