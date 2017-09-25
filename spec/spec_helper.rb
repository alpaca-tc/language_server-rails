# frozen_string_literal: true

require 'bundler/setup'
require 'language_server_json'

RSpec.configure do |config|
  config.order = :random
  config.raise_errors_for_deprecations!
  config.profile_examples = 10
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
