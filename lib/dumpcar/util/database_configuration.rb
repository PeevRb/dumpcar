# frozen_string_literal: true

module Dumpcar::Util
  class DatabaseConfiguration
    # the db_config passed in
    attr_reader :db_config

    # generally, you will use #create since it does the work for getting the proper config on your current Rails version.
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

    # Reliably provides a db configuration hash no matter how the has is received.
    # This adapts between Rails 6.0 which uses ActiveRecord::Base.connection_config is, itself a hash, and 6.1+
    # which uses ActiveRecord::Base.connection_db_config which is an object with a `#configuration_hash` method
    def configuration_hash
      @db_config.respond_to?(:configuration_hash) ? @db_config.configuration_hash : @db_config
    end

    # instantiate your DatabaseConfiguration object with the ActiveRecord::Base connection db config, regardless of what version of Rails you're on.
    def self.create
      new(get_base_connection_db_config)
    end

    # This adapts between Rails 6.0 which uses ActiveRecord::Base.connection_config and 6.1+ which uses ActiveRecord::Base.connection_db_config
    def self.get_base_connection_db_config
      ActiveRecord::Base.respond_to?(:connection_db_config) ? ActiveRecord::Base.connection_db_config : ActiveRecord::Base.connection_config
    end
  end
end
