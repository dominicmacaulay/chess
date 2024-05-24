require_relative '../lib/chess'

RSpec.describe Game do
    test = Game.new
    describe "create_board" do
        array = test.create_board
        it "returns an array with a length of 8" do
            expect(array.length).to eql(8)
        end
        it "returns an array with 8 nested arrays with a length of 8" do
            length = 0
            array.each do |sub_array|
                length += sub_array.length
            end
            expect(length).to eql(64)
        end
        it "creates a second row with white pawns and seventh row with black pawns" do
            pawns = true
            array.each do |sub_array|
                unless sub_array[1].name == "wp" && sub_array[6].name == "bp"
                    pawns = false
                end
            end
            expect(pawns).to be true
        end
        it "creates a first row with white pieces and last row with black pieces" do
            pieces = true
            unless array[0][7].name == "br" && array[7][7].name == "br"
                pieces = false
            end
            unless array[1][7].name == "bk" && array[6][7].name == "bk"
                pieces = false
            end
            unless array[2][7].name =="bb" && array[5][7].name =="bb"
                pieces = false
            end
            unless array[3][7].name == "bK"
                pieces = false
            end
            unless array[4][7].name == "bQ"
                pieces = false
            end
            unless array[0][0].name == "wr" && array[7][0].name == "wr"
                pieces = false
            end
            unless array[1][0].name == "wk" && array[6][0].name == "wk"
                pieces = false
            end
            unless array[2][0].name =="wb" && array[5][0].name =="wb"
                pieces = false
            end
            unless array[3][0].name == "wK"
                pieces = false
            end
            unless array[4][0].name == "wQ"
                pieces = false
            end
            expect(pieces).to be true
        end
        it "Leaves empty spaces in the middle four rows" do
            empty = true
            array.each do |sub_array|
                unless sub_array[2] == nil && sub_array[3] == nil && sub_array[4] == nil && sub_array[5] == nil
                    empty = false
                end
            end
            expect(empty).to be true
        end
    end
    describe "clean_input" do
        it "should return a clean array" do
            array = test.clean_input("1-2", "5-3")
            new_array = [[0,1],[4,2]]
            expect(array).to eql(new_array)
        end
    end
    describe "validate_input" do
        it "should return true if valid" do
            expect(test.validate_input("white", [[7,0],[4,4]])).to be true
        end
        it "should return false if invalid" do
            expect(test.validate_input("black", [[7,0],[4,4]])).to be false
        end
        it "should return false if the values are equal" do
            expect(test.validate_input("white", [[7,7],[7,7]])).to be false
        end
        it "should return false if the move is out of range" do
            expect(test.validate_input("white", [[7,0],[8,4]])).to be false
            expect(test.validate_input("white", [[7,0],[4,-1]])).to be false
        end
    end
    describe "move_piece" do
        piece = test.board[0][1]
        move = test.board[0][2]
        it "should move the piece to the new position" do
            test.move_piece(piece, [0,1], move, [0,2], false)
            old_spot = test.board[0][1]
            new_spot = test.board[0][2]

            expect(old_spot).to eql(nil)
            expect(new_spot.name).to eql("wp")
        end
        it "should move the piece back" do
            test.move_piece(piece, [0,1], move, [0,2], true)
            old_spot = test.board[0][1]
            new_spot = test.board[0][2]

            expect(old_spot.name).to eql("wp")
            expect(new_spot).to eql(nil)
        end
    end
    describe "find_king" do
        it "returns the white king piece" do
            piece = test.find_king("white")
            expect(piece.name).to eql("wK")
        end
        it "returns the black king piece" do
            piece = test.find_king("black")
            expect(piece.name).to eql("bK")
        end
    end
    describe "check" do
        test = Game.new
        it "returns false when king is not in check" do
            expect(test.check("white")).to be false
        end
        it "returns true when king is in check" do
            test.board[4][1] = nil
            test.move_piece(test.board[4][7], [4,7], test.board[7,4], [7,4], false)
            test.board[7][4].position = [7,4]
            expect(test.check("white")).to be true
        end
    end
    describe "checkmate" do
        test_checkmate_false = Game.new
        it "returns false if not in check" do
            expect(test_checkmate_false.checkmate("white",false,[0,0])).to be false
        end
        it "returns false if in check but can be blocked" do
            test_checkmate_false.validate_piece_move([[2,1],[2,3]], "white")
            test_checkmate_false.validate_piece_move([[3,6],[3,4]], "black")
            test_checkmate_false.validate_piece_move([[7,1],[7,3]], "white")
            test_checkmate_false.validate_piece_move([[4,7],[0,3]], "black")
            expect(test_checkmate_false.checkmate("white",true,[0,3])).to be false
        end
        it "returns false if in check but can be beaten" do
            test_checkmate_false.validate_piece_move([[1,1],[1,2]], "white")
            test_checkmate_false.validate_piece_move([[0,3],[1,2]], "black")
            expect(test_checkmate_false.checkmate("white",true,[1,2])).to be false
        end
        it "returns false if in check but king can move" do
            test_checkmate_false2 = Game.new
            test_checkmate_false2.validate_piece_move([[2,1],[2,3]], "white")
            test_checkmate_false2.validate_piece_move([[3,6],[3,4]], "black")
            test_checkmate_false2.validate_piece_move([[1,1],[1,3]], "white")
            test_checkmate_false2.validate_piece_move([[0,6],[0,4]], "black")
            test_checkmate_false2.validate_piece_move([[3,1],[3,3]], "white")
            test_checkmate_false2.validate_piece_move([[4,7],[0,3]], "black")
            expect(test_checkmate_false2.checkmate("white",true,[0,3])).to be false
        end
        test_checkmate_true = Game.new
        it "should return true" do
            test_checkmate_true.validate_piece_move([[2,1],[2,2]], "white")
            test_checkmate_true.validate_piece_move([[3,6],[3,4]], "black")
            test_checkmate_true.validate_piece_move([[1,1],[1,3]], "white")
            test_checkmate_true.validate_piece_move([[4,7],[0,3]], "black")
            expect(test_checkmate_true.checkmate("white",true,[0,3])).to be true
        end
    end
end