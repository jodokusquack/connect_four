class Player

  attr_accessor :sign

  def initialize(sign:)
    @sign = sign
  end

  def ask_for_move
    puts "Player #{@sign}, please enter the column for your move:"
    begin
      input = gets.chomp.downcase.to_i
    end while !((1..7) === input)

    input
  end
end


