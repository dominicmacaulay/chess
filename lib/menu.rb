require_relative 'chess'

def game_menu
    puts "Welcome to Chess"
    puts "To load a game, type 'load game' and press enter"
    puts "To start a new game, just press enter"
    choice = gets.chomp.downcase
    if choice == "load game"
        this_game = Game.load_game
    else
        this_game = Game.new
    end
    this_game.game_loop
end

game_menu