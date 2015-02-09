require 'rspec'
require 'canada_post'
require 'support/vcr'
require 'support/credentials'

RSpec.configure do |c|
  c.filter_run_excluding :production unless canada_post_production_credentials
  c.expect_with :rspec do |expect_config|
    expect_config.syntax = :expect
  end
end