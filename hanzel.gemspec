# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.add_runtime_dependency(%q<rails>, [">= 3.2.x"])

  gem.authors = ["Justin Erny"]
  gem.email = 'jerny@vail.com'
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.files = `git ls-files`.split("\n")
  gem.rdoc_options = ["--main", "README.rdoc", "--line-numbers", "--inline-source"]
  gem.require_paths = ["lib"]
  gem.name = 'hanzel'
  gem.summary = %q{tobe added}
  gem.test_files = `git ls-files -- spec/* test/*`.split("\n")
  gem.version = "1.0.0"
end

