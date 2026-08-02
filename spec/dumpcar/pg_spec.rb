RSpec.describe Dumpcar::Pg do
  describe ":dump" do
    it "does not crash" do
      pg = described_class.new(Dumpcar::Util::DatabaseConfiguration.create.configuration_hash)

      pg.dump(Rails.root.join("tmp/#{Random.uuid}.dump").to_s)
    end

    it "properly dumps and restores an item" do
      pg = described_class.new(Dumpcar::Util::DatabaseConfiguration.create.configuration_hash)

      expect(SimpleObject.count).to eq 0
      SimpleObject.create(name: "so-1")

      dump_file = Rails.root.join("tmp/#{Random.uuid}.dump").to_s

      pg.dump(dump_file)

      SimpleObject.delete_all

      expect(SimpleObject.count).to eq 0
      pg.restore(dump_file)

      expect(SimpleObject.count).to eq 1
    end
  end

  describe ":restore" do
    it "does not crash" do
      pg = described_class.new(Dumpcar::Util::DatabaseConfiguration.create.configuration_hash)

      expect { pg.restore(Dumpcar::Location.new(Rails.root.join("db/dumps")).last) }.to_not raise_error
    end

    it "properly restores an item" do
      pg = described_class.new(Dumpcar::Util::DatabaseConfiguration.create.configuration_hash)

      expect(SimpleObject.count).to eq 0
      pg.restore(Dumpcar::Location.new(Rails.root.join("db/dumps")).last)

      expect(SimpleObject.count).to eq 3
    end
  end
end
