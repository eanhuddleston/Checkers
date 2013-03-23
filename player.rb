class Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end
  
  # REV: The break, next, and nested if statements makes this a bit hard to follow.
  #      However the method names are great.

  def make_move
    while true  
      start_coord, end_coord = get_move_coords
      piece = @board.board[start_coord[0]][start_coord[1]]

      if piece.nil? or piece.is_a?(WhiteSquare)
        puts "That's not a piece; try again."
        next
      elsif piece.color != @color
        puts "You can only move your own pieces! Try again."
        next
      elsif piece.valid_for_one_space?(end_coord)
        piece.move_one_space(end_coord)
        break
      elsif piece.valid_for_jumping?(end_coord)
        piece.jump(end_coord)
        if piece.any_valid_jumps?
          @board.print_board
          puts "Please go again:"
          self.make_move
        end
        break
      else
        puts "That's not a valid move; please try again."
      end
    end
  end

  def get_move_coords
    puts "Enter coordinate of piece to move:"
    start_coord = gets.chomp.split(' ').map {|i| i.to_i}
    puts "Enter destination coordinate:"
    end_coord = gets.chomp.split(' ').map {|i| i.to_i}

    return [start_coord, end_coord]  # REV: You don't need a return here. 
  end
end