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
end
