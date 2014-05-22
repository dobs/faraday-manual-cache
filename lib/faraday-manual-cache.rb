require 'faraday/manual_cache'

if Faraday.respond_to?(:register_middleware)
  Faraday.register_middleware manual_cache: Faraday::ManualCache
elsif Faraday::Middleware.respond_to?(:register_middleware)
  Faraday::Middleware.register_middleware manual_cache: Faraday::ManualCache
end
