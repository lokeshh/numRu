require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :pry do |task|
  sh 'pry -r ./lib/numru.rb'
end
