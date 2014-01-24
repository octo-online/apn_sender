require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "apn2/version"

task :gem => :build
task :build do
  system "gem build apn_sender.gemspec"
end

task :install => :build do
  system "gem install apn_sender-#{APN2::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{APN2::VERSION} -m 'Tagging #{APN2::VERSION}'"
  system "git push --tags"
  system "gem push apn_sender-#{APN2::VERSION}.gem"
  system "rm apn_sender-#{APN2::VERSION}.gem"
end

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

RSpec::Core::RakeTask.new('spec:progress') do |spec|
  spec.rspec_opts = %w(--format progress)
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
