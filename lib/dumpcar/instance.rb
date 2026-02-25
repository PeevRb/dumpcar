module Dumpcar
  class Instance
    require "active_model"
    include ActiveModel::Model

    attr_accessor :connection, :location, :pg, :base_dir, :description
    def initialize(attributes = {})
      cleanup_arguments(attributes)
      @connection = Dumpcar::Util.get_connection_db_config
      @location = Location.new(base_dir)
      @pg = Pg.new(connection)
    end

    def dump
      @pg.dump(@location.next(description))
    end

    def restore
      @pg.restore(@location.last)
    end

    def cleanup_arguments(arguments)
      arguments = arguments.to_h.with_indifferent_access
      unless arguments.has_key?("base_dir")
        arguments["base_dir"] = Rails.root.join("db/dumps")
      end

      assign_attributes(arguments)
    end
  end
end
