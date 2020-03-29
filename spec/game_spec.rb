require './lib/game.rb'
require './lib/player.rb'

RSpec.describe Game do
  describe "#new_game" do
    it "creates a new board" do
      game = Game.new
      board = double(:board)
      allow(board).to receive(:setup)

      game.new_game(board: board)

      expect(board).to have_received(:setup)
    end

    it "creates two new players" do
      game = Game.new
      board = double(:board, :setup => nil)

      game.new_game(board: board)

      expect(game.players.length).to eq 2
    end
  end

  describe "#play" do
    it "cycles between the players" do
      game = Game.new
      players = double(:players)
      allow(players).to receive(:cycle)
      board = double(:board, :setup => nil)
      game.new_game(players: players, board: board)

      game.play

      expect(players).to have_received(:cycle)
    end

    it "asks the player for a move" do
      game = Game.new
      player = double(:player)
      players = double(:players)
      allow(players).to receive(:cycle).and_yield(player)
      allow(player).to receive_messages(:ask_for_move => nil, :sign =>
                                        nil)
      board = double(:board,
                     :setup => nil,
                     :set_cell => true,
                     :game_over? => false,
                     :full? => false)
      game.new_game(players: players, board: board)

      game.play

      expect(player).to have_received(:ask_for_move)
    end

    it "adds the players sign to the column" do
      game = Game.new
      player = double(:player)
      players = double(:players)
      allow(players).to receive(:cycle).and_yield(player)
      allow(player).to receive(:ask_for_move).and_return 3
      allow(player).to receive(:sign).and_return "X"
      board = double(:board,
                     :setup => nil,
                     :game_over? => false,
                     :full? => false)
      allow(board).to receive(:set_cell).and_return true
      game.new_game(players: players, board: board)

      game.play

      expect(player).to have_received(:sign)
      expect(board).to have_received(:set_cell).with("X", 3)
    end

    it "keeps asking for input until a valid col is given" do
      game = Game.new
      player = double(:player)
      players = double(:players)
      allow(players).to receive(:cycle).and_yield(player)
      allow(player).to receive(:ask_for_move).and_return(1,2,3)
      allow(player).to receive(:sign).and_return "X"
      board = double(:board,
                     :setup => nil,
                     :game_over? => false,
                     :full? => false)
      allow(board).to receive(:set_cell).and_return(false, false, true)
      game.new_game(players: players, board: board)

      game.play

      expect(player).to have_received(:sign).exactly(3).times
      expect(board).to have_received(:set_cell).exactly(3).times
    end

    it "checks if somebody has won" do
      game = Game.new
      player = double(:player)
      players = double(:players)
      allow(players).to receive(:cycle).and_yield(player)
      allow(player).to receive(:ask_for_move).and_return 3
      allow(player).to receive(:sign).and_return "X"
      board = double(:board,
                     :setup => nil,
                     :game_over? => true,
                     :full? => false)
      allow(board).to receive(:set_cell).and_return true
      game.new_game(players: players, board: board)

      expect { game.play }.to output(/Congratulations/).to_stdout
      expect(board).to have_received(:game_over?)
    end

    it "checks if the board is full" do
      game = Game.new
      player = double(:player)
      players = double(:players)
      allow(players).to receive(:cycle).and_yield(player)
      allow(player).to receive(:ask_for_move).and_return 3
      allow(player).to receive(:sign).and_return "X"
      board = double(:board,
                     :setup => nil,
                     :game_over? => false,
                     :full? => true)
      allow(board).to receive(:set_cell).and_return true
      game.new_game(players: players, board: board)

      expect { game.play }.to output(/tie/).to_stdout
      expect(board).to have_received(:full?)
    end
  end

  describe "#play_again?" do
      it "asks the players to play again?" do
          game = Game.new
          allow(game).to receive(:gets).and_return("n\n")

          expect { game.play_again? }.to output(/Thanks/).to_stdout
      end

      it "returns true if the players want to" do
          game = Game.new
          allow(game).to receive(:gets).and_return("\n")

          ans = game.play_again?

          expect(ans).to eq true
      end
  end
end
