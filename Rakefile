require 'rake'
require 'bundler/setup'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Dir['rake/*.rb'].each { |filename| load filename }

task :test => %w(rspec)

task :default => %w(bundle:audit rubocop test)
