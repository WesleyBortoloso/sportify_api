require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SportifyApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3001'
        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 expose: ['Authorization']
      end
    end

    config.middleware.use Warden::Manager do |manager|
      Devise.warden_config = manager
    end
  end
end
