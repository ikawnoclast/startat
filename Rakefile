##### KAW: this is all a mess and completely broken


#!/usr/bin/env rake
require "bundler/gem_tasks"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bundler/version"
 
task :build do
  system "gem build bundler.gemspec"
end
 
task :release => :build do
  system "gem push bundler-#{Bunder::VERSION}"
end
