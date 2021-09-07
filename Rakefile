# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["test/*_test.rb"]
  t.verbose = true
end

task default: %i(test)

task :release, %i(release) => %i(
  build
  release:rubygem_push
)
