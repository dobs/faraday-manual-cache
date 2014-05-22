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

  * `expires_in`: Cache expiry, in seconds (default 30).
  * `store`: The `ActiveSupport::Cache`-compatible store to use (default `ActiveSupport::Cache::MemoryStore`).
  * `store_options`: Options passed to the store if created by lookup (e.g. when specifying `:memory_store`, `:redis_store`, etc).

So a more complicated example would be:

```ruby
require 'faraday'
require 'faraday-manual-cache'
require 'redis-rails'

connection = Faraday.new(url: 'http://example.com') do |builder|
  builder.use :manual_cache, expires_in: 10, store: :redis_store, store_options: { host: 'my-redis-server', port: '1234' }
  builder.adapter Faraday.default_adapter
end
```

As with `faraday-http-cache` it's recommended that `faraday-manual-cache` be fairly low in the middleware stack.

## TODO

  * Additional cache key options.
  * Request header for bypassing caching when necessary.
  * Response header for indicating when response is a cached copy. 

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