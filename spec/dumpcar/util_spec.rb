RSpec.describe Dumpcar::Util do
  describe "calculate_dump_description" do
    [
      ["name with upper and down case", "An item with UPPER and downcase", "an-item-with-upper-and-downcase"],
      ["name with two spaces", "An  item with spaces", "an-item-with-spaces"],
      ["name with space at front and end", " An  item with Space at front and end  ", "an-item-with-space-at-front-and-end"],
      ["name with space with doublespace and dash", "An -item with space and Dash", "an-item-with-space-and-dash"]
    ].each do |title, input, expected|
      it "properly handles #{title}" do
        expect(described_class.calculate_dump_description(input)).to eq expected
      end
    end
  end
end
