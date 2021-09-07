# frozen_string_literal: true

require "bundler/gem_tasks"

task default: %i[test]

task :test do
  sh "bundle exec ruby -Ilib:test test/*_test.rb"
end

task :release, %i[release] => %i[
  build
  release:rubygem_push
]
