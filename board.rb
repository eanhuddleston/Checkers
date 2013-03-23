class Board
  attr_accessor :board

  def initialize
    @board = new_board
  end

  def new_board
    board = Array.new(8) { Array.new {nil} }

    black_piece_coords = [ [0,1],[0,3],[0,5],[0,7],[1,0],[1,2],
                    [1,4],[1,6],[2,1],[2,3],[2,5],[2,7] ]
    black_piece_coords.each do |coord|
      board[coord[0]][coord[1]] = Piece.new(:B, coord, self)
    end
    
    white_piece_coords = [ [5,0],[5,2],[5,4],[5,6],[6,1],[6,3],
                    [6,5],[6,7],[7,0],[7,2],[7,4],[7,6] ]
    white_piece_coords.each do |coord|
      board[coord[0]][coord[1]] = Piece.new(:W, coord, self)
    end

    flush_coords = [0,2,4,6]
    offset_coords = [1,3,5,7]

    white_square_flush_coords = [0,2,4,6]
    white_square_flush_coords.each do |row|
      flush_coords.each do |pos|
        board[row][pos] = WhiteSquare.new
      end
    end
    white_square_indent_coords = [1,3,5,7]
    white_square_indent_coords.each do |row|
      offset_coords.each do |pos|
        board[row][pos] = WhiteSquare.new
      end
    end

    board
  end

  def any_pieces_left?(color)
    pieces = find_pieces(color)
    if !pieces.empty?
      true
    else
      false
    end
  end

  def find_pieces(color)
    all_pieces = []
    @board.flatten.each do |piece|
      if !piece.nil? and !piece.is_a?(WhiteSquare) #we have an object
        if piece.color == color
          all_pieces << piece
        end
      end
    end

    all_pieces
  end

  def any_moves_left?(color)
    all_pieces = find_pieces(color)

    all_pieces.each do |piece|
      return true if piece.any_poss_moves?
    end

    false
  end

  def has_won?(color)
    opp_color = nil
    if color == :W
      opp_color = :B
    else
      opp_color = :W
    end

    if !any_pieces_left?(opp_color) or !any_moves_left?(opp_color)
      return true
    else
      return false
    end
  end

  def print_board
    puts "  0 1 2 3 4 5 6 7"
    @board.each_with_index do |row, i|
      print_line = ""
      print_line << "#{i} "
      row.each_with_index do |square, j|
        print_line << "*" if nil
        if square.is_a?(King)
          print_line << "K" if square.color == :B
          print_line << "C" if square.color == :W
        elsif square.is_a?(Piece)
          print_line << "B" if square.color == :B
          print_line << "W" if square.color == :W
        elsif square.is_a?(WhiteSquare)
          print_line << "*"
        elsif square.nil?
          print_line << "_"
        end
        print_line << " " unless j == 7
      end
      puts print_line
    end
    puts ""
  end
end