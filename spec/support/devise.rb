RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.include Warden::Test::Helpers, type: :request
  config.after(:example, type: :feature) { Warden.test_reset! }
  config.after(:example, type: :request) { Warden.test_reset! }
end
