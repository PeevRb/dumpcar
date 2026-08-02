# frozen_string_literal: true

module Dumpcar::Util
  class DatabaseConfiguration
    def initialize(db_config)
      @db_config = db_config
    end

    def connection_type
      case @db_config
      in Hash
        :unknown
      in ActiveRecord::DatabaseConfigurations::UrlConfig
        :url
      in ActiveRecord::DatabaseConfigurations::HashConfig
        :hash
      end
    end

    def configuration_hash
      @db_config.respond_to?(:connection_hash) ? @db_config.configuration_hash : @db_config
    end

    def self.create
      new(get_base_connection_db_config)
    end

    def self.get_base_connection_db_config
      ActiveRecord::Base.respond_to?(:connection_db_config) ? ActiveRecord::Base.connection_db_config : ActiveRecord::Base.connection_config
    end
  end
end
