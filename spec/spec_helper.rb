# frozen_string_literal: true

require "bundler"

require "simplecov"

if ENV["CI"]
  require "simplecov-cobertura"

  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.start

Bundler.require :default, :development

Combustion.initialize! :active_record

require "rspec/rails"
require "dumpcar"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include ActiveSupport::Testing::TimeHelpers

  # Use the GitHub Annotations formatter for CI
  if ENV["GITHUB_ACTIONS"] == "true"
    require "rspec/github"
    config.add_formatter RSpec::Github::Formatter
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

::Dir.glob(::File.expand_path("../support/*.rb", __FILE__)).each { |f| require_relative f }
::Dir.glob(::File.expand_path("../support/**/*.rb", __FILE__)).each { |f| require_relative f }
