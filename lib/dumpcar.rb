require "dumpcar/version"
require "dumpcar/location"
require "dumpcar/pg"
require "dumpcar/util"
require "dumpcar/util/database_configuration"
require "dumpcar/instance"
require "dumpcar/railtie" if defined?(Rails)

module Dumpcar
  def self.dump
    Instance.new.dump
  end

  def self.restore
    Instance.new.restore
  end
end
