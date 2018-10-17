require 'bundler/setup'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)


# Cell router
require 'real_world/ports/router/in_memory'
router = RealWorld::Ports::Router::InMemory.new

# API
require 'real_world/api/cell'

api = RealWorld::API::Cell.new(
  router: router,
)

# HTTP interface
require 'real_world/ports/http_interface/rack'

http_interface = RealWorld::Ports::HTTPInterface::Rack.new
http_interface.subscribe(api.command(:api_handle_request))

run http_interface
