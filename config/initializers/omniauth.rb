require 'omniauth/strategies/ynab'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ynab, ENV['YNAB_CLIENT_ID'], ENV['YNAB_CLIENT_SECRET']
end