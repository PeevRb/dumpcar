# frozen_string_literal: true

require_relative "lib/dumpcar/version"

Gem::Specification.new do |spec|
  spec.name = "dumpcar"
  spec.version = Dumpcar::VERSION
  spec.authors = ["Eric Schultz"]
  spec.email = ["eric@wwahammy.com"]

  spec.summary = "Commands for dumping and restoring Rails PostgreSQL database contents"
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/peevrb/dumpcar"
  spec.license = "LGPL-3.0-or-later"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails", ">= 6"
  spec.add_dependency "terrapin", ">= 1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
