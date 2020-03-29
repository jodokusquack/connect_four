#! /usr/bin/env ruby
# connect_four.rb


Dir["./lib/*.rb"].each { |file| require file }

game = Game.new
begin
  begin
    game.new_game
    again = game.play
  end while again
rescue Interrupt
  abort("Thanks for playing")
end
