require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec) do |task|
  task.rspec_opts = '--require spec_helper'
  task.pattern = Dir.glob('lib/**/*_spec.rb')
end
