module Dumpcar
  class Location
    TIMESTAMP_STRFTIME_FORMAT = "%Y%m%d%H%M%S"
    TIMESTAMP_GLOB = 14.times.map { "[0-9]" }.join
    TIMESTAMP_FILE_GLOB = TIMESTAMP_GLOB + "*.dump"

    attr_reader :base_dir
    def initialize(base_dir)
      @base_dir = Pathname.new base_dir
    end

    def dumps
      prepare_base_dir!
      base_dir.glob(TIMESTAMP_FILE_GLOB)
    end

    def first
      prepare_base_dir!
      dumps.first
    end

    def search(query)
      dumps.first { |file| file.basename.starts_with(query) }
    end

    def last
      prepare_base_dir!
      dumps.last
    end

    def next(description = nil)
      prepare_base_dir!
      base_dir.join(generate_file_name(description)).to_s
    end

    def from_time(time = Time.now.utc)
      time.strftime(TIMESTAMP_STRFTIME_FORMAT)
    end

    private

    def prepare_base_dir!
      FileUtils.mkdir_p base_dir
    end

    def generate_file_name(description)
      [
        from_time,
        description ? Dumpcar::Util.calculate_dump_description(description) : nil
      ].reject(&:nil?).join("-") + ".dump"
    end
  end
end
