require 'colmena/port_injection'
require 'colmena/response'

module Colmena
  class Command
    include Colmena::PortInjection
    include Colmena::Response
  end
end
