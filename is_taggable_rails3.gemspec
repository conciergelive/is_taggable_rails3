require_relative './lib/is_taggable/version'

Gem::Specification.new do |s|
  s.name = "is_taggable_rails3"
  s.version = IsTaggable::VERSION

  s.required_ruby_version = Gem::Requirement.new(">= 2.1")
  s.authors = ["Martin Emde", "Daniel Haran", "James Golick", "GiraffeSoft Inc.", "Ben Johnson", "Drew Ulmer"]
  s.email = ["martin.emde@gmail.com", "dulmer@conciergelive.com"]
  s.files = Dir["lib/**/*"]
  s.require_paths = ["lib"]
  s.homepage = "https://github.com/conciergelive/is_taggable_rails3"
  s.license = "MIT"
  s.description = %q{Rails 3 patched version of is_taggable}
  s.summary = %q{Rails 3 patched version of is_taggable}

  s.add_development_dependency 'activerecord', '~> 3.2'
  s.add_development_dependency 'activesupport', '~> 3.2'
  s.add_development_dependency 'sqlite3', '~> 1.3.5'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'pry'
end
