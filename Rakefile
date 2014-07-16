require "bundler/gem_tasks"
require "bundler/setup"
require "rake/testtask"

task :default => :test

desc "Run the Test Suite, toot suite"
task :test do
  sh "rspec spec/*_spec.rb spec/**/*_spec.rb"
end
