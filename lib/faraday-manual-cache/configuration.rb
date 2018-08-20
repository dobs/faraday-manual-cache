module FaradayManualCache
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :memory_store

    def initialize
      @memory_store = ActiveSupport::Cache::MemoryStore.new
    end
  end
end
