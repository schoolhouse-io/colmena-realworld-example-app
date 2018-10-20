require 'colmena/port_injection'
require 'colmena/callable'
require 'colmena/response'

module Colmena
  class Query
    include Colmena::PortInjection
    include Colmena::Callable
    include Colmena::Response
  end
end
