RSpec.describe Dumpcar::Util do
  describe ".logger_class" do
    it "returns ActiveSupport::BroadcastLogger on Rails 7.0" do
      expect(Rails).to receive(:version).and_return "7.0"

      expect(described_class.logger_class).to eq Dumpcar::Util::BroadcastLogger
    end

    if Rails.version >= "7.1" # you can't test for ActiveSupport::BroadcastLogger if we're not on Rails 7.1
      it "returns ActiveSupport::BroadcastLogger on Rails 7.1" do
        expect(Rails).to receive(:version).and_return "7.1"

        expect(described_class.logger_class).to eq ActiveSupport::BroadcastLogger
      end
    end
  end

  describe ".logger" do
    around do |example|
      original_stdout = $stdout
      original_rails_logger = Rails.logger

      begin
        # override $stdout so we can read it
        $stdout = StringIO.new("", "w")
        example.run
      ensure
        # we're resetting to the original stdout
        $stdout = original_stdout
        # we're resetting to the Rails.logger
        Rails.logger = original_rails_logger
      end
    end

    it "is writing to stdout" do
      Dumpcar::Util.logger.fatal("LOUD NOISES!!!")

      expect($stdout.string).to include("LOUD NOISES!!!")
    end

    it "is writing to Rails.logger" do
      test_strio = StringIO.new("", "w")
      # override Rails.logger so we can read its IO
      Rails.logger = Logger.new(test_strio)

      Dumpcar::Util.logger.fatal("LOUD NOISES!!!")

      expect(test_strio.string).to include("LOUD NOISES!!!")
    end
  end
end
