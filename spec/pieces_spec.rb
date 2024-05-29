require_relative '../lib/pieces'

RSpec.describe Pawn do
    describe "create a pawn" do
        test = Pawn.new('w', 'b', [1,1])
        it "creates a all attributes" do
            expect(test.color).to eql('w')
            expect(test.opposite_color).to eql('b')
            expect(test.name).to eql('wp')
            expect(test.original_position).to eql ([1,1])
            expect(test.position).to eql ([1,1])
        end
        it "creates a valid move set for white" do
            move_set = [[0,1],[-1,1],[1,1],[0,2]]
            expect(test.get_move_set).to eql(move_set)
        end
        it "creates a valid move set for black" do
            test = Pawn.new('b','w',[1,1])
            move_set = [[0,-1],[-1,-1],[1,-1],[0,-2]]
            expect(test.get_move_set).to eql(move_set)
        end
    end 
    describe "validates for valid white moves" do
        board = [[nil, nil, Pawn.new('b','w',[0,2])],[nil,"pawn", nil, nil],[nil, nil, Pawn.new('b','w',[2,2])]]
        it "returns true and moves for valid two forward move" do
            test = Pawn.new('w', 'b', [1,1])
            expect(test.validate_move([1,3],board,true)).to be true
            expect(test.position).to eql([1,3])
        end
        it "returns true and moves for valid one forward move" do
            test = Pawn.new('w', 'b',[1,1])
            expect(test.validate_move([1,2],board,true)).to be true
            expect(test.position).to eql([1,2])
        end
        it "returns true and moves for valid left move" do
            test = Pawn.new('w','b',[1,1])
            expect(test.validate_move([0,2],board,true)).to be true
            expect(test.position).to eql([0,2])
        end
        it "returns true and moves for valid right move" do
            test = Pawn.new('w','b',[1,1])
            expect(test.validate_move([2,2],board,true)).to be true
            expect(test.position).to eql([2,2])
        end
        it "returns true but does not move" do
            test = Pawn.new('w','b',[1,1])
            expect(test.validate_move([0,2],board,false)).to be true
            expect(test.validate_move([1,3],board,false)).to be true
            expect(test.validate_move([1,2],board,false)).to be true
            expect(test.validate_move([2,2],board,false)).to be true
            expect(test.position).to eql([1,1])
        end
    end
    describe "validates for valid black moves" do
        board = Array.new(8) {Array.new(8, nil)}
        board[5][5] = Pawn.new('w', 'b', [5,5])
        board[7][5] = Pawn.new('w','b', [7,5])
        it "returns true and moves for valid one forward move" do
            test = Pawn.new('b','w',[6,6])
            expect(test.validate_move([6,5],board,true)).to be true
            expect(test.position).to eql([6,5])
        end
        it "returns true and moves for valid two forward move" do
            test = Pawn.new('b','w',[6,6])
            expect(test.validate_move([6,4],board,true)).to be true
            expect(test.position).to eql([6,4])
        end
    end
    describe "validates for invalid moves" do
        test = Pawn.new('w','b',[1,1])
        board = [[nil, nil, Pawn.new('w', 'b', [0,2])],[nil, nil, Pawn.new('b','w',[1,2])],[nil,nil,nil]]
        it "returns false for one forward" do
            expect(test.validate_move([1,2],board,true)).to be false
        end
        it "returns false for one left" do
            expect(test.validate_move([0,2],board,true)).to be false
        end
        it "returns false for one forward" do
            expect(test.validate_move([2,2],board,true)).to be false
        end
        board2 = [[nil],[nil,nil,nil,Pawn.new('w','b',[1,3])]]
        it "returns false for two forward" do
            expect(test.validate_move([1,3],board2,true)).to be false
        end
        new_pawn = Pawn.new('w','b',[1,1])
        new_pawn.position = [1,2]
        it "returns false for two forward if already moved" do
            expect(new_pawn.validate_move([1,4],board2,true)).to be false
        end
    end
end

RSpec.describe Rook do
    describe "creates a new rook" do
        test = Rook.new("w", [0,1])
        it "creates all attributes" do
            expect(test.color).to eql("w")
            expect(test.name).to eql("wr")
            expect(test.position).to eql([0,1])
            expect(test.unmoved).to eql(true)
            move_set = [[0,1],[0,-1],[1,0],[-1,0]]
            expect(test.move_set).to eql(move_set)
        end
    end
    describe "validates a valid move" do
        board = [[nil,nil,nil,Rook.new("b",[0,3])]]
        test = Rook.new("w", [0,0])
        it "validates a move forward and moves" do
            expect(test.validate_move([0,2],board,true)).to be true
            expect(test.unmoved).to eql(false)
            expect(test.position).to eql([0,2])
        end
        it "validates taking an enemy" do
            expect(test.validate_move([0,3],board,true)).to be true
            expect(test.position).to eql([0,3])
        end
        it "validates but doesn't move" do
            expect(test.validate_move([0,2],board,false)).to be true
            expect(test.unmoved).to eql(false)
            expect(test.position).to eql([0,3])
        end
    end
    describe "validates an invalid move" do
        board = Array.new(8) {Array.new(8,nil)}
        board[0][1] = Rook.new("w",[0,1])
        test = Rook.new("w",[0,0])
        it "returns false for diagonal move" do
            expect(test.validate_move([1,1],board,true)).to be false
        end
        it "returns false if piece is in the way" do
            expect(test.validate_move([0,2],board,true)).to be false
        end
        it "returns false if piece to take is the same color" do
            expect(test.validate_move([0,1],board,true)).to be false
        end
    end
end

RSpec.describe Knight do
    describe "creates a new knight" do
        test = Knight.new("w", [0,1])
        it "creates all attributes" do
            expect(test.color).to eql("w")
            expect(test.name).to eql("wk")
            expect(test.position).to eql([0,1])
            move_set = [[1,-2],[2,-1],[2,1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2]]
            expect(test.move_set).to eql(move_set)
        end
    end
    describe "validates a valid move" do
        test = Knight.new("w", [0,0])
        board = [[nil,nil,nil],[nil,nil,Knight.new("b",[1,2])],[nil,nil]]
        it "validates but doesn't move to take an enemy" do
            expect(test.validate_move([1,2],board,false)).to be true
            expect(test.position).to eql([0,0])
        end
        it "validates and moves to an empty space" do
            expect(test.validate_move([2,1],board,true)).to be true
            expect(test.position).to eql([2,1])
        end
    end
    describe "validates invalid move" do
        test = Knight.new("w", [0,0])
        board = [[nil,nil,nil],[nil,nil,Knight.new("w",[1,2])],[nil,nil]]
        it "returns false for invalid move" do
            expect(test.validate_move([1,1],board,true)).to be false
        end
        it "returns false if the move is to a piece of the same color" do
            expect(test.validate_move([1,2],board,true)).to be false
        end
    end
end

RSpec.describe Bishop do
    describe "creates a new bishop" do
        test = Bishop.new("w", [0,1])
        it "creates all attributes" do
            expect(test.color).to eql("w")
            expect(test.name).to eql("wb")
            expect(test.position).to eql([0,1])
            move_set = [[1,-1],[1,1],[-1,1],[-1,-1]]
            expect(test.move_set).to eql(move_set)
        end
    end
    describe "validates valid moves" do
        test = Bishop.new("w",[2,2])
        board = Array.new(8) {Array.new(8,nil)}
        board[4][0] = Bishop.new("b",[4,0])
        it "returns true but doesn't move valid move" do
            expect(test.validate_move([0,0],board,false)).to be true
            expect(test.position).to eql([2,2])
        end
        it "returns true and moves to take enemy" do
            expect(test.validate_move([4,0],board,true)).to be true
            expect(test.position).to eql([4,0])
        end
    end
    describe "validates invalid moves" do 
        test = Bishop.new("w",[2,2])
        board = Array.new(8) {Array.new(8,nil)}
        board[4][0] = Bishop.new("w",[4,0])
        board[1][1] = Bishop.new("b",[1,1])
        it "returns false for invalid move" do
            expect(test.validate_move([2,1],board,true)).to be false
        end
        it "returns false for move to piece of same color" do
            expect(test.validate_move([4,0],board,true)).to be false
        end
        it "returns false if piece is in the way" do
            expect(test.validate_move([0,0],board,true)).to be false
        end
    end
end

RSpec.describe King do
    describe "creates a new King" do
        test = King.new("w", [0,1])
        it "creates all attributes" do
            expect(test.color).to eql("w")
            expect(test.name).to eql("wK")
            expect(test.position).to eql([0,1])
            expect(test.unmoved).to eql(true)
            move_set = [[1,-1],[1,1],[-1,1],[-1,-1],[0,1],[0,-1],[1,0],[-1,0]]
            expect(test.move_set).to eql(move_set)
        end
    end  
    board = [[nil,nil,nil],[King.new("w",[1,0]),King.new("b",[1,1])]]
    describe "validates valid moves" do
        test = King.new("w",[0,0])
        it "returns true but doesnt move for valid move" do
            expect(test.validate_move([0,1],board,false)).to be true
            expect(test.unmoved).to eql(true)
            expect(test.position).to eql([0,0])
        end
        it "returns true and moves to take an enemy" do
            expect(test.validate_move([1,1],board,true)).to be true
            expect(test.unmoved).to eql(false)
            expect(test.position).to eql([1,1])
        end
    end
    describe "validates invalid moves" do
        test = King.new("w",[0,0])
        it "returns false if move is invalid" do
            expect(test.validate_move([0,2],board,true)).to be false
        end
        it "returns false if move is to piece of same color" do
            expect(test.validate_move([1,0],board,true)).to be false
        end
    end
end

RSpec.describe Queen do
    describe "creates a new Queen" do
        test = Queen.new("w", [0,1])
        it "creates all attributes" do
            expect(test.color).to eql("w")
            expect(test.name).to eql("wQ")
            expect(test.position).to eql([0,1])
            move_set = [[1,-1],[1,1],[-1,1],[-1,-1],[0,1],[0,-1],[1,0],[-1,0]]
            expect(test.move_set).to eql(move_set)
        end
    end  
    describe "validates valid moves" do
        test = Queen.new("w",[2,2])
        board = Array.new(8) {Array.new(8,nil)}
        board[4][0] = Queen.new("b",[4,0])
        it "returns true but doesn't move a valid move" do
            expect(test.validate_move([2,0],board,false)).to be true
            expect(test.position).to eql([2,2])
        end
        it "returns true and moves to enemy" do
            expect(test.validate_move([4,0],board, true)).to be true
            expect(test.position).to eql([4,0])
        end
    end
    describe "validates invalid moves" do
        test = Queen.new("w",[2,2])
        board = Array.new(8) {Array.new(8,nil)}
        board[4][0] = Queen.new("w",[4,0])
        board[1][1] = Queen.new("b",[1,1])
        it "returns false for invalid move" do
            expect(test.validate_move([3,0],board,true)).to be false
        end
        it "returns false for move to the same color" do
            expect(test.validate_move([4,0],board,true)).to be false
        end
        it "returns false if piece is in the way" do
            expect(test.validate_move([0,0],board,true)).to be false
        end
    end
end