require './lib/board.rb'
require './lib/player.rb'
require './lib/cell.rb'


RSpec.describe Board do

  describe "#setup" do

    it "sets up a board with a 7x6 array of emtpy cells" do
      board = Board.new

      board.setup

      expect(board.cells.length).to eq 7
      expect(board.cells[0].length).to eq 6
    end
  end

  describe "#display_to_screen" do
    it "displays the board the screen" do
      board = Board.new

      board.setup

      expect { board.display_to_screen }.to output(/\|1\|2\|3\|4\|5\|6\|7\|/).to_stdout
    end
  end

  describe "#set_cell" do
    context "when there are still free cells" do
      it "sets the topmost cell to the given content" do
        test_cell = double(:test_cell, :content => " ", :content= => nil)
        cell = double(:cell)
        cells = [
          [test_cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
        ]
        board = Board.new
        board.setup(cells: cells)

        possible = board.set_cell(content: "X", col:0)

        expect(test_cell).to have_received(:content=).with("X")
        expect(possible).to eq true
      end
    end

    context "when all cells are full" do
      it "returns false if the column is already full" do
        full_cell = double(:full_cell, :content => "X", :content= => nil)
        test_cell = double(:test_cell, :content => "X", :content= => nil)
        cell = double(:cell)
        cells = [
          [full_cell, full_cell, full_cell, full_cell, full_cell, test_cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
          [cell, cell, cell, cell, cell, cell],
        ]
        board = Board.new
        board.setup(cells: cells)

        possible = board.set_cell(content: "X", col:0)

        expect(test_cell).to_not have_received(:content=).with("X")
        expect(possible).to eq false
      end
    end
  end

  describe "#game_over?" do

    let(:x_cell){ double(:x_cell, :content => "X") }
    let(:o_cell){ double(:o_cell, :content => "O") }
    let(:e_cell){ double(:e_cell, :content => " ") }

    context "when no player has completed four in a row" do
      it "returns false" do
        cells = [
          [x_cell, o_cell, x_cell, o_cell, e_cell, e_cell],
          [x_cell, x_cell, e_cell, e_cell, e_cell, e_cell],
          [o_cell, x_cell, x_cell, o_cell, o_cell, e_cell],
          [o_cell, x_cell, o_cell, o_cell, o_cell, e_cell],
          [o_cell, o_cell, o_cell, x_cell, x_cell, o_cell],
          [x_cell, x_cell, o_cell, x_cell, x_cell, o_cell],
          [x_cell, o_cell, x_cell, x_cell, x_cell, o_cell],
        ]
        board = Board.new
        board.setup(cells: cells)

        expect( board.game_over?(6) ).to eq false
      end
    end
    context "when a player has completed four in a vertical row" do
      it "returns true" do
        cells = [
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [x_cell, x_cell, x_cell, x_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
        ]
        board = Board.new
        board.setup(cells: cells)

        expect( board.game_over?(1) ).to eq true

      end
    end

    context "when a player has completed four in a horizontal row" do
      it "returns true" do
        cells = [
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [x_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [x_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [x_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [x_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
        ]
        board = Board.new
        board.setup(cells: cells)

        expect( board.game_over?(4) ).to eq true
      end
    end

    context "when a player has completed four in a diagonal" do
      it "returns true" do
        cells = [
          [e_cell, e_cell, e_cell, e_cell, x_cell, e_cell],
          [e_cell, e_cell, e_cell, x_cell, e_cell, e_cell],
          [o_cell, o_cell, x_cell, e_cell, e_cell, e_cell],
          [e_cell, x_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
          [e_cell, e_cell, e_cell, e_cell, e_cell, e_cell],
        ]
        board = Board.new
        board.setup(cells: cells)

        expect( board.game_over?(2) ).to eq true
      end
    end
  end

  describe "#full?" do
    context "when the board is full" do
      it "returns true" do
        board = Board.new
        cells = double(:cells)
        board.setup(cells: cells, free_cells: 0)


        expect(board.full?).to eq true
      end
    end

    context "when the board is not yet full" do
      it "returns false" do
        board = Board.new
        cells = double(:cells)
        board.setup(cells: cells, free_cells: 25)

        expect(board.full?).to eq false
      end
    end
  end
end
