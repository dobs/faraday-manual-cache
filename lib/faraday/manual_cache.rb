require 'faraday'

module Faraday
  # Middleware for caching Faraday responses based on a specified expiry.
  #
  # As with faraday-http-cache, it's recommended that this middleware be added
  # fairly low in the middleware stack.
  #
  # Currently accepts four arguments:
  #
  #   :expires_in    - Cache expiry, in seconds (default: 30).
  #   :store         - An object (or lookup symbol) for an
  #                    ActiveSupport::Cache::Store instance. (default:
  #                    MemoryStore).
  #   :store_options - Options to pass to the store when generated based on a
  #                    lookup symvol (default: {}).
  class ManualCache < Faraday::Middleware
    def initialize(app, *args)
      super(app)
      options = args.first || {}
      @expires_in    = options.fetch(:expires_in, 30)
      @store         = options.fetch(:store, :memory_store)
      @store_options = options.fetch(:store_options, {})

      initialize_store
    end

    def call(env)
      dup.call!(env)
    end

    protected

    def call!(env)
      return to_response(cached_response(env)) if cacheable?(env) &&
        cached_response(env)

      @app.call(env).on_complete do |response_env|
        cache_response(response_env) if cacheable?(env)
      end
    end

    # Cache the env to the store.
    def cache_response(env)
      @store.write(env.url, env, expires_in: @expires_in)
    end

    # Whether or not the env is cacheable.
    def cacheable?(env)
      env.method == :get || env.method == :head
    end

    # Retrieve (and memoize) cached response matching current env.
    def cached_response(env)
      @cached_response ||= @store.fetch(env.url)
    end

    # Checks whether the specified store is a symbol, and if so attempts to
    # do a lookup against ActiveSupport::Cache.
    def initialize_store
      return unless @store.is_a? Symbol

      require 'active_support/cache'
      @store = ActiveSupport::Cache.lookup_store(@store, @store_options)
    end

    # Massage env into a Response object.
    def to_response(env)
      response = Response.new
      response.finish(env) unless env.parallel?
      env.response = response
    end
  end
end
