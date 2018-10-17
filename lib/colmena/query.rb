require 'colmena/port_injection'
require 'colmena/response'

module Colmena
  class Query
    include Colmena::PortInjection
    include Colmena::Response
  end
end
