# Faraday::ManualCache

A super simple Faraday cache implementation.

Unlike [`faraday-http-cache`](https://github.com/plataformatec/faraday-http-cache), `faraday-manual-cache` ignores cache headers in favor of a manually-specified `expires_in`.

## Installation

Add this line to your application's Gemfile:

    gem 'faraday-manual-cache'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday-manual-cache

## Configuration

Create a configuration file and select your memory store class. If you use Rails, just create an initializator.

```ruby
FaradayManualCache.configure do |config|
  config.memory_store = ActiveSupport::Cache::MemoryStore.new
end
```

## Usage

Super simple example that caches using the default store (`MemoryStore`) for the default expires_in (30 seconds):

```ruby
require 'faraday'
require 'faraday-manual-cache'

connection = Faraday.new(url: 'http://example.com') do |builder|
  builder.use :manual_cache
  builder.adapter Faraday.default_adapter
end
```
The middleware currently takes several options:

  * `conditions`: Conditional caching (default GET and HEAD requests).
  * `cache_key`: Key for requests comparison (default URL)
  * `expires_in`: Cache expiry, in seconds (default 30).
  * `logger`: Specify a logger to enable logging.

So a more complicated example would be:

```ruby
require 'faraday'
require 'faraday-manual-cache'

connection = Faraday.new(url: 'http://example.com') do |builder|
  builder.use :manual_cache,
              conditions: ->(env) { env.method == :get },
              cache_key: ->(env) { "prefix-#{env.url}" },
              expires_in: 10,
              logger: Rails.logger
  builder.adapter Faraday.default_adapter
end
```

As with `faraday-http-cache` it's recommended that `faraday-manual-cache` be fairly low in the middleware stack.

## Contributing

1. Fork it ( http://github.com/dobs/faraday-manual-cache/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Attribution

Some implementation details taken from [`faraday-http-cache`](https://github.com/plataformatec/faraday-http-cache).

## Contributors

  * Maintainer: [Daniel O'Brien](http://github.com/dobs)
