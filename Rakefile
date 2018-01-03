require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--tag ~integration"
end
task :default => :spec

task :console do
  $LOAD_PATH << "lib"
  require "lifx"
  require "pry"
  if ENV['DEBUG']
    LIFX::LAN::Config.logger.level = Logger::DEBUG
  end
  LIFX::LAN::Client.lan.discover! do |c|
    c.lights.count > 0
  end
  LIFX::LAN::Client.lan.pry
end
