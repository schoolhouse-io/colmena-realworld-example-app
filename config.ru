require 'bundler/setup'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# SQL connection
# We use in-memory SQLite, but we could use a different engine like PostgreSQL
# without affecting other code
require 'sequel'
sql_connection = Sequel.connect('sqlite:memory')

# Cell router
require 'real_world/ports/router/in_memory'
router = RealWorld::Ports::Router::InMemory.new

# Event broker
require 'real_world/ports/event_broker/in_memory'
event_broker = RealWorld::Ports::EventBroker::InMemory.new

# Auth
require 'real_world/auth/cell'
require 'real_world/auth/ports/repository/sql'

auth = RealWorld::Auth::Cell.new(
  repository: RealWorld::Auth::Ports::Repository::SQL.new(sql_connection),
  event_publisher: event_broker,
)

router.register_cell(auth)

# User
require 'real_world/user/cell'
require 'real_world/user/ports/repository/sql'

user = RealWorld::User::Cell.new(
  repository: RealWorld::User::Ports::Repository::SQL.new(sql_connection),
  event_publisher: event_broker,
)

router.register_cell(user)

# Api
require 'real_world/api/cell'
require 'real_world/api/ports/tokens/jwt'

api = RealWorld::Api::Cell.new(
  router: router,
  tokens: RealWorld::Api::Ports::Tokens::JWT.new,
)

router.register_cell(api)

# HTTP interface
require 'real_world/ports/http_interface/rack'

http_interface = RealWorld::Ports::HttpInterface::Rack.new
http_interface.subscribe(api)

run http_interface
