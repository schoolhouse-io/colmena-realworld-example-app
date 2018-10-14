require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/real_world/**/*.rb', 'spec/real_world/**/*.rb']
end
