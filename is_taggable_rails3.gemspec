Gem::Specification.new do |s|
  s.name = %q{is_taggable_rails3}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Emde", "Daniel Haran", "James Golick", "GiraffeSoft Inc.", "Ben Johnson", "Drew Ulmer"]
  s.date = %q{2009-09-12}
  s.email = %q{martin.emde@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc",
  ]
  s.files = [
    ".gitignore",
    "LICENSE",
    "README.rdoc",
    "VERSION.yml",
    "generators/is_taggable_migration/is_taggable_migration_generator.rb",
    "generators/is_taggable_migration/templates/migration.rb",
    "init.rb",
    "is_taggable.gemspec",
    "lib/is_taggable.rb",
    "lib/tag.rb",
    "lib/tagging.rb",
    "rakefile",
    "test/is_taggable_test.rb",
    "test/tag_test.rb",
    "test/tagging_test.rb",
    "test/test_helper.rb",
  ]
  s.homepage = %q{http://github.com/conciergelive/is_taggable_rails3}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Rails 3 patched version of is_taggable}
  s.test_files = [
    "test/is_taggable_test.rb",
    "test/tag_test.rb",
    "test/tagging_test.rb",
    "test/test_helper.rb",
  ]

  if s.respond_to? :specification_version
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end
