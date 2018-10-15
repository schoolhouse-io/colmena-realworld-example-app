module Colmena
  # This mixin provides a simple interface to inject and access cell ports
  module Component
    def initialize(ports={})
      @ports = ports
    end

    def port(name)
      @ports.fetch(name)
    end
  end
end
