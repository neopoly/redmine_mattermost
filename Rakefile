#!/usr/bin/env rake

require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new(:spec) do |test|
  test.test_files = FileList['spec/**/*_spec.rb']
  test.libs << 'spec'
  test.verbose = true
end

task default: [:spec]
