require 'bundler/setup'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

run ->(env) { [200, {}, ["Hello, world!"]] }
