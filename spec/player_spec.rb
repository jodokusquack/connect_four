require './lib/player.rb'

RSpec.describe Player do

  subject(:player){ Player.new(sign: "X") }

  describe '#sign' do
    it "returns the sign of the player" do
      expect(player.sign).to eq "X"
    end
  end

  describe "#ask_for_move" do
    it "should ask the human for a move" do
      allow(player).to receive(:gets).and_return("7\n")

      player.ask_for_move

      expect(player).to have_received(:gets)
    end

    it "should return the chosen column" do
      allow(player).to receive(:gets).and_return("3\n")

      col = player.ask_for_move

      expect(col).to eq 3
    end

    it "should keep asking when invalid input is given" do
      allow(player).to receive(:gets).and_return("9\n", "invalid\n", "wrong\n",
                                                 "5\n")

      col = player.ask_for_move

      expect(col).to eq 5
    end
  end
end
