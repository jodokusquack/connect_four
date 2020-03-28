require './lib/cell.rb'

RSpec.describe Cell do

  subject(:cell){ Cell.new(content: "X") }

  describe "#content" do
    it "returns the content of the cell" do
      expect(cell.content).to eq "X"
    end
  end

  describe "#to_s" do
    it "prints its content to the screen" do
      expect { puts cell }.to output("X\n").to_stdout
    end
  end

  describe "#==" do
    it "returns true if two cells have the same content" do
      other = Cell.new(content: "X")

      expect(cell == other).to eq true
    end

    it "returns false if the other cell has a different content" do
      other = Cell.new(content: "O")

      expect(cell == other).to eq false
    end

    it "returns false when compared to something that isn't a cell" do
      other = "X"

      expect( cell == other ).to eq false
    end
  end
end
