class Game

  attr_accessor :players, :board

  def new_game(board: nil, players: nil)
    @board = board || Board.new
    @board.setup
    @players = players || [Player.new(sign: "X"), Player.new(sign: "O")]
  end

  def play
    message = ""
    players.cycle(nil) do |player|
      system "clear"
      board.display_to_screen
      puts
      begin
        col = player.ask_for_move - 1

        valid = board.set_cell(content: player.sign, col: col)
      end while !valid

      if board.game_over?(col)
        message = "Congratulations!! Player #{player.sign} won!"
        break
      elsif board.full?
        message = "It's a tie!"
        break
      end
    end
    system "clear"
    board.display_to_screen
    puts
    puts message
    puts

    play_again?
  end

  def play_again?

    puts "Do you want to play again? [Y/n]"
    answer = gets.chomp.downcase[0]

    if ["n", "q"].include? answer
      puts "Thanks for playing!!"
      false
    else
      true
    end
  end
end
