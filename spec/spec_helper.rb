require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

begin
  require File.expand_path('../dummy/config/environment', __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
  exit
end

require 'pry'
require 'ffaker'
require 'factory_bot'
require 'selenium/webdriver'
require 'rspec/rails'
require 'shoulda/matchers'

include Warden::Test::Helpers
Warden.test_mode!

capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  'chromeOptions' => {
    'args' => ['--headless', '--disable-gpu']
  }
)

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.javascript_driver = :chrome

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.fail_fast = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.before :each do
    Rails.cache.clear
  end
end

Dir[File.join(File.dirname(__FILE__), '/support/**/*.rb')].each { |file| require file }
