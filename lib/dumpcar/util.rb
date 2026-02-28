module Dumpcar::Util
  def self.get_connection_db_config
    (Rails.version < "6.1") ? ActiveRecord::Base.connection_config : ActiveRecord::Base.connection_db_config.configuration_hash
  end

  def self.logger_class
    if Rails.version < "7.1"
      # We only load this if we needed it
      require "dumpcar/util/broadcast_logger"
      Dumpcar::Util::BroadcastLogger
    else
      ActiveSupport::BroadcastLogger
    end
  end

  def self.logger
    logger_class.new(Rails.logger, Logger.new($stdout))
  end
end
