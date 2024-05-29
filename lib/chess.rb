require_relative './pieces.rb'
require 'yaml'
class Game 
    attr_reader :board
    def initialize
        setup
    end
    def setup
        @board = create_board
        @player = "white"
        @king_check = false
        @last_piece = nil
    end
    # creates the basic game board with all of the pieces in their starting positions
    def create_board
        # create a the basic array
        array = Array.new(8) {Array.new(8, nil)}
        # create all of the pawns
        index = 0
        until index > 7
            array[index][1] = Pawn.new('w', 'b', [index, 1],)
            array[index][6] = Pawn.new('b', 'w', [index, 6])
            index += 1
        end
        # adds pieces for the white row first, then the black row
        index = 0
        color = "w"
        until index > 7
            array[0][index] = Rook.new(color, [0,index])
            array[1][index] = Knight.new(color, [1,index])
            array[2][index] = Bishop.new(color, [2,index])
            array[3][index] = King.new(color, [3,index])
            array[4][index] = Queen.new(color, [4,index])
            array[5][index] = Bishop.new(color, [5,index])
            array[6][index] = Knight.new(color, [6,index])
            array[7][index] = Rook.new(color, [7,index])
            color = "b"
            index += 7
        end
        return array
    end
    # displays the game depending on the player
    def display_board(player)
        if player == "black"
            index = 0
            until index > 7
                @board[0][index].nil? ? p1 = "  " : p1 = @board[0][index].name
                @board[1][index].nil? ? p2 = "  " : p2 = @board[1][index].name
                @board[2][index].nil? ? p3 = "  " : p3 = @board[2][index].name
                @board[3][index].nil? ? p4 = "  " : p4 = @board[3][index].name
                @board[4][index].nil? ? p5 = "  " : p5 = @board[4][index].name
                @board[5][index].nil? ? p6 = "  " : p6 = @board[5][index].name
                @board[6][index].nil? ? p7 = "  " : p7 = @board[6][index].name
                @board[7][index].nil? ? p8 = "  " : p8 = @board[7][index].name
                puts "-------------------------"
                puts "|#{p1}|#{p2}|#{p3}|#{p4}|#{p5}|#{p6}|#{p7}|#{p8}|#{index+1}"
                index += 1
            end
            puts "-------------------------"
            puts "| 1| 2| 3| 4| 5| 6| 7| 8| "
        else
            index = 7
            until index < 0
                @board[7][index].nil? ? p1 = "  " : p1 = @board[7][index].name
                @board[6][index].nil? ? p2 = "  " : p2 = @board[6][index].name
                @board[5][index].nil? ? p3 = "  " : p3 = @board[5][index].name
                @board[4][index].nil? ? p4 = "  " : p4 = @board[4][index].name
                @board[3][index].nil? ? p5 = "  " : p5 = @board[3][index].name
                @board[2][index].nil? ? p6 = "  " : p6 = @board[2][index].name
                @board[1][index].nil? ? p7 = "  " : p7 = @board[1][index].name
                @board[0][index].nil? ? p8 = "  " : p8 = @board[0][index].name
                puts "-------------------------"
                puts "|#{p1}|#{p2}|#{p3}|#{p4}|#{p5}|#{p6}|#{p7}|#{p8}|#{index+1}"
                index -= 1
            end
            puts "-------------------------"
            puts "| 8| 7| 6| 5| 4| 3| 2| 1| "
        end
    end
    # this is the game loop
    def game_loop
        # the game will loop until the checkmate method returns true
        until checkmate(@player,@king_check, @last_piece) == true
            # puts messages indicating whose turn it is and the if the player is in check
            display_board(@player)
            puts "#{@player.capitalize} player's turn"
            puts "You are in check" if @king_check == true
            # use a method to get the player's input
            input = get_input
            # ensure that the player has chosen one of their pieces and then make sure that the move is valid
            until validate_input(@player, input) == true && validate_piece_move(input, @player) == true
                # continue to get input until the input is valid
                input = get_input
            end
            # assuming that the player has made a valid move, then the player is no longer in check
            @king_check = false
            # retreive the coordinates of the piece that was just played for checkmate validation
            @last_piece = [input[1][0],input[1][1]]
            # change the player
            @player == "white" ? @player = "black" : @player = "white"
            # check if the player is in check
            if check(@player) == true
                @king_check = true
            end
            # ask to save the game
            ask_save_game
        end
        display_board(@player)
        @player == "white" ? player2 = "black" : player2 = "white"
        puts "Checkmate!"
        puts "#{player2.capitalize} player has beaten #{@player.capitalize} player!"
    end
    # gets the player's input and returns an array with the piece and move coordinates
    def get_input
        puts "Enter the coordinates of the piece you would like to move"
        puts "by column then row ie. 1-2"
        piece = gets.chomp
        puts "Enter the coordinates of where you would like to move the piece to "
        puts "by column then row ie. 5-3"
        move = gets.chomp
        # call clean input to get an array with two sets of coordinates in it
        array = clean_input(piece, move)
        return array
    end
    # splits string and places it into an array
    def clean_input(piece, move)
        # split the strings into arrays
        p_array = piece.split("")
        m_array = move.split("")
        # create empty arrays to house the integers
        p_coords = []
        m_coords = []
        # add the integer versions of the string arrays to the integer arrays
        p_array.each do |elem|
            p_coords.push(elem.to_i)
        end
        m_array.each do |elem|
            m_coords.push(elem.to_i)
        end
        # create a final array with the piece and move coordinates decreased by one to represent index values
        array = [[(p_coords[0] - 1), (p_coords[-1] - 1)], [(m_coords[0] - 1), (m_coords[-1] - 1)]]
        return array
    end
    # validates that the selected piece is one of the player's pieces
    def validate_input(player, input)
        input.each do |array|
            array.each do |elem|
                unless elem.between?(0,7)
                    puts "Error: has to be between 1 and 8"
                    return false
                end
            end
        end
        if input[0][0]==input[1][0] && input[0][1]==input[1][1]
            puts "Error: cannot move a piece to its own position"
            return false
        end
        if @board[input[0][0]][input[0][1]]&.color == player[0]
            return true
        else
            puts "Error: cannot move something that is not yours"
            return false
        end
    end
    # vaidates that the proposed move is a valid one that can be made and doesn't put the king in check
    def validate_piece_move(input, player, move_piece = true)
        # fetch the piece and move items from the board
        piece = @board[input[0][0]][input[0][1]]
        piece_coords = [input[0][0],input[0][1]]
        move = @board[input[1][0]][input[1][1]]
        move_coords = [input[1][0],input[1][1]]
        # check that the move is not one of the player's pieces
        unless move&.color == player[0]
            # check the piece's validate move method to ensure that the move can be made by the piece
            if piece.validate_move(move_coords, @board, true) == true
                # move the piece on the board
                move_piece(piece, piece_coords, move, move_coords)
                # determine whether the player is in check after moving
                in_check = check(player)
                # if the player is in check or if the method is not supposed to move the piece
                if in_check == true || move_piece == false
                    # move the piece back
                    move_piece(piece, piece_coords, move, move_coords, true)
                    # change the piece's coordinates back to the old position
                    piece.position = piece_coords
                    puts "Your King is still in check!" if move_piece == true
                    # return false if in check is true
                    return false if in_check == true
                end
                return true
            else
                puts "Error: your piece cannot move there" if move_piece == true
                return false
            end
        end
        puts "Error: cannot move to another of your own pieces" if move_piece == true
        return false
    end
    # moves the piece on the board
    def move_piece(piece, piece_coords, move, move_coords, move_back = false)
        # check if the method is moving pieces back to how they were or not
        if move_back == false
            # move the piece to the new position and make the old position nil
            @board[move_coords[0]][move_coords[1]] = piece
            @board[piece_coords[0]][piece_coords[1]] = nil
        else
            # return the pieces back to how they were
            @board[piece_coords[0]][piece_coords[1]] = piece
            @board[move_coords[0]][move_coords[1]] = move
        end
    end
    # checks if the given player is in check
    def check(player)
        # retreive the king
        king = find_king(player)
        # loop through the board
        @board.each do |array|
            array.each do |elem|
                # check if the element is the opponent's piece
                unless elem.nil?
                    unless elem.color == player[0]
                        # return true if the piece can move to the king's position
                        return true if elem.validate_move(king.position, @board) == true
                    end
                end
            end
        end
        return false
    end
    # finds the given player's king
    def find_king(player)
        # loop through the board
        @board.each do |array|
            array.each do |elem|
                # if the element is the given player's piece
                if elem&.name == "#{player[0]}K"
                    # return the element
                    return elem
                end
            end
        end
    end
    # determines whether the given player is in checkmate
    def checkmate(player, check, piece)
        # return false if the player is not in check
        return false if check == false
        # retreive the given player's king
        king = find_king(player)
        # retreive an array of the coordinates from the king to the piece
        coords = get_coords_between(king, piece)
        # loop through the board
        @board.each do |array|
            array.each do |elem|
                # check if the element is one of the player's pieces
                if elem&.color == player[0] && elem&.name
                    coords.each do |coord|
                        return false if validate_piece_move([elem.position, coord], player, false) == true
                    end
                end
            end
        end
        # retreive the king's move_set
        move_set = king.move_set
        # loop through the move_set
        move_set.each do |move|
            # check if the king make the move
            if validate_piece_move([king.position,[(king.position[0] + move[0]),(king.position[1] + move[1])]],player, false) == true
                return false
            end
        end
        return true
    end
    # gets the coordinates between the king and the given piece
    def get_coords_between(king, piece)
        move_set = king.move_set
        move_set.each do |move|
            position = king.position
            array = []
            while position[0].between?(0,7) && position[1].between?(0,7)
                position = [(position[0] + move[0]), (position[1] + move[1])]
                array.push(position)
                return array if position == piece
            end
        end
    end
    def ask_save_game
        puts "Would you like to save the game?"
        puts "Enter 'yes' to save or just hit enter"
        input = gets.chomp
        if input.downcase == "yes"
            save_game
            puts "Game saved"
        end
    end
    # YAML save and load methods
    def save_game
        File.open('./saved_game.yml', 'w') { |file| file.write(YAML.dump(self)) }
    end
    def self.load_game
        YAML.safe_load(File.read('./saved_game.yml'), permitted_classes: [Game, Rook, Knight, Bishop, King, Queen, Pawn], aliases: true)
    end
end