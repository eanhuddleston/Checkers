require './piece.rb'
require './player.rb'
require './board.rb'

class Game
  def initialize
    @board = Board.new
    @white_player = Player.new(:W, @board)
    @black_player = Player.new(:B, @board)
  end

  def play
    while true
      @board.print_board
      puts "White player's turn:"
      @white_player.make_move
      @board.print_board
      if @board.has_won?(:W)
        puts "You win!!!"
        break
      end
      puts "Black player's turn:"
      @black_player.make_move
      @board.print_board
      if @board.has_won?(:B)
        puts "You win!!!"
        break
      end
    end
  end
end

Game.new.play


# Notes for later:
# b = Board.new
# b[[1,2]]
# def [](pos)
#   self.board[row]
# end
#
# def []=(row)
#   self.board[row]
# end
