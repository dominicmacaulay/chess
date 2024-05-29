class Pawn
    attr_accessor :color, :opposite_color, :name, :original_position, :position, :move_set
    def initialize(color, opposite_color, position)
        @color = color
        @opposite_color = opposite_color
        @name = "#{color}p"
        @original_position = position
        @position = position
        @move_set = get_move_set
    end
    def get_move_set
        if @color == "w"
            return [[0,1],[-1,1],[1,1],[0,2]]
        else
            return [[0,-1],[-1,-1],[1,-1],[0,-2]]
        end
    end
    def validate_move(move, board, move_piece = false)

        if move == [(@position[0] + @move_set[1][0]),(@position[1] + @move_set[1][1])]
            if board[(@position[0] + @move_set[1][0])][(@position[1] + @move_set[1][1])]&.color == @opposite_color
                @position = [(@position[0] + @move_set[1][0]),(@position[1] + @move_set[1][1])] if move_piece == true
                return true
            end
        elsif move == [(@position[0] + @move_set[2][0]),(@position[1] + @move_set[2][1])]
            if board[(@position[0] + @move_set[2][0])][(@position[1] + @move_set[2][1])]&.color == @opposite_color
                @position = [(@position[0] + @move_set[2][0]),(@position[1] + @move_set[2][1])] if move_piece == true
                return true
            end
        elsif board[@position[0]][@position[1] + @move_set[0][1]] == nil
            if move == [(@position[0] + @move_set[0][0]),(@position[1] + @move_set[0][1])]
                @position = [(@position[0] + @move_set[0][0]), (@position[1] + @move_set[0][1])] if move_piece == true
                return true
            elsif board[@position[0]][@position[1] + @move_set[3][1]] == nil
                if @position == @original_position
                    if move == [(@position[0] + @move_set[3][0]),(@position[1] + @move_set[3][1])]
                        @position = [(@position[0] + @move_set[3][0]),(@position[1] + @move_set[3][1])] if move_piece == true
                        return true
                    end
                end
            end
        end
        return false
    end
end
class Rook
    attr_accessor :color, :name, :position, :move_set, :unmoved
    def initialize(color, position)
        @color = color
        @name = "#{color}r"
        @position = position
        @move_set = [[0,1],[0,-1],[1,0],[-1,0]]
        @unmoved = true
    end
    def validate_move(move, board, move_piece = false)
        @move_set.each do |coords|
            temp_position = [(@position[0] + coords[0]),(@position[1] + coords[1])]
            while 0 == 0
                if temp_position == move
                    unless board[temp_position[0]][temp_position[1]]&.color == @color
                        if move_piece == true
                            @position = temp_position 
                            @unmoved = false
                        end
                        return true
                    end
                    return false
                end
                break unless temp_position[0].between?(0,7) && temp_position[1].between?(0,7)
                break unless board[temp_position[0]][temp_position[1]].nil?
                temp_position = [(temp_position[0] + coords[0]),(temp_position[1] + coords[1])]
            end
        end
        return false
    end
end
class Knight
    attr_accessor :color, :name, :position, :move_set
    def initialize(color, position)
        @color = color
        @name = "#{color}k"
        @position = position
        @move_set = [[1,-2],[2,-1],[2,1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2]]
    end
    def validate_move(move, board, move_piece = false)
        @move_set.each do |coords|
            temp_position = [(@position[0] + coords[0]),(@position[1] + coords[1])]
            if temp_position[0].between?(0,7) && temp_position[1].between?(0,7) && temp_position == move
                unless board[temp_position[0]][temp_position[1]]&.color == @color
                    @position = temp_position if move_piece == true
                    return true
                end
                return false
            end
        end
        return false
    end
end
class Bishop
    attr_accessor :color, :name, :position, :move_set
    def initialize(color, position)
        @color = color
        @name = "#{color}b"
        @position = position
        @move_set = [[1,-1],[1,1],[-1,1],[-1,-1]]
    end
    def validate_move(move, board, move_piece = false)
        @move_set.each do |coords|
            temp_position = [(@position[0] + coords[0]),(@position[1] + coords[1])]
            while 0 == 0
                if temp_position == move
                    unless board[temp_position[0]][temp_position[1]]&.color == @color
                        @position = temp_position if move_piece == true
                        return true
                    end
                    return false
                end
                break unless temp_position[0].between?(0,7) && temp_position[1].between?(0,7)
                break unless board[temp_position[0]][temp_position[1]].nil?
                temp_position = [(temp_position[0] + coords[0]),(temp_position[1] + coords[1])]
            end
        end
        return false
    end
end
class King
    attr_accessor :color, :name, :position, :move_set, :unmoved
    def initialize(color, position)
        @color = color
        @name = "#{color}K"
        @position = position
        @move_set = [[1,-1],[1,1],[-1,1],[-1,-1],[0,1],[0,-1],[1,0],[-1,0]]
        @unmoved = true
    end
    def validate_move(move, board, move_piece = false)
        @move_set.each do |coords|
            temp_position = [(@position[0] + coords[0]),(@position[1] + coords[1])]
            if temp_position[0].between?(0,7) && temp_position[1].between?(0,7) && temp_position == move
                unless board[temp_position[0]][temp_position[1]]&.color == @color
                    if move_piece == true
                        @position = temp_position 
                        @unmoved = false
                    end
                    return true
                end
                return false
            end
        end
        return false
    end
end
class Queen
    attr_accessor :color, :name, :position, :move_set
    def initialize(color, position)
        @color = color
        @name = "#{color}Q"
        @position = position
        @move_set = [[1,-1],[1,1],[-1,1],[-1,-1],[0,1],[0,-1],[1,0],[-1,0]]
    end
    def validate_move(move, board, move_piece = false)
        @move_set.each do |coords|
            temp_position = [(@position[0] + coords[0]),(@position[1] + coords[1])]
            while 0 == 0
                if temp_position == move
                    unless board[temp_position[0]][temp_position[1]]&.color == @color
                        @position = temp_position if move_piece == true
                        return true
                    end
                    return false
                end
                break unless temp_position[0].between?(0,7) && temp_position[1].between?(0,7)
                break unless board[temp_position[0]][temp_position[1]].nil?
                temp_position = [(temp_position[0] + coords[0]),(temp_position[1] + coords[1])]
            end
        end
        return false
    end
end
