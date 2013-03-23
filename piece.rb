class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
    @valid_trans = []
    @valid_jump_trans = []
    set_valid_trans
  end

  def move_one_space(end_coord)
    @board.board[@position[0]][@position[1]] = nil
    @board.board[end_coord[0]][end_coord[1]] = self
    @position = end_coord
    king_me if end_of_board?
  end

  def jump(end_coord)
    coord_to_capture = [ (@position[0] + end_coord[0])/2,
        (@position[1] + end_coord[1])/2 ]

    @board.board[@position[0]][@position[1]] = nil
    @board.board[end_coord[0]][end_coord[1]] = self
    @position = end_coord
    @board.board[coord_to_capture[0]][coord_to_capture[1]] = nil
    king_me if end_of_board?
  end

  def any_poss_moves?
    all_poss_trans = @valid_trans + @valid_jump_trans
    all_poss_trans.each do |trans|
      end_pos = [ @position[0] + trans[0],
          @position[1] + trans[1] ]
      return true if valid_move?(end_pos)
    end

    false
  end

  def set_valid_trans
    if @color == :B
      @valid_trans = [ [1,-1], [1,1] ]
      @valid_jump_trans = [ [2,-2], [2,2] ]
    elsif @color == :W
      @valid_trans = [ [-1,-1], [-1,1] ]
      @valid_jump_trans = [ [-2,-2], [-2,2] ]
    end
  end

  def valid_move?(coord)
    valid_for_one_space?(coord) or valid_for_jumping?(coord)
  end

  def any_valid_jumps?
    @valid_jump_trans.each do |trans|
      new_pos = [ @position[0] + trans[0],
          @position[1] + trans[1] ]
      if in_bounds?(new_pos) and valid_for_jumping?(new_pos)
        return true
      end
    end
    false
  end

  def valid_for_jumping?(coord)
    puts "@position: #{@position}"
    @valid_trans.each_with_index do |trans, i|
      puts "loops through: #{i}"
      one_step = [ @position[0] + trans[0],
          @position[1] + trans[1] ]
      #puts "one_step: #{one_step}"
      puts "@position: #{@position}"
      puts "in_bounds: #{in_bounds?(one_step)}"
      puts "trans: #{trans}"
      next if !in_bounds?(one_step)
      piece = @board.board[one_step[0]][one_step[1]]
      #piece is one step
      if !piece.nil?
        if piece.color == @color
          next #can't jump own guy; use next trans
        elsif piece.color != @color
          two_steps = [ one_step[0] + trans[0],
              one_step[1] + trans[1] ]
          puts "one_step: #{one_step}"
          puts "two_steps: #{two_steps}"
          piece2 = @board.board[two_steps[0]][two_steps[1]]
          puts "piece2: #{piece2.nil?}"
          if piece2.nil?
            # puts "two_steps: #{two_steps}"
#             puts "coord: #{coord}"
            puts "two_steps == coord: #{two_steps == coord}"
            return true if two_steps == coord
          end
        end
      else
        next
      end
    end

    false
  end

  def valid_for_one_space?(coord)
    return false if !in_bounds?(coord)
    piece = @board.board[ coord[0] ][ coord[1] ]

    valid_moves = []
    @valid_trans.each do |trans|
      possible_move = [ position[0] + trans[0],
          position[1] + trans[1] ]
      valid_moves << possible_move
    end

    return true if piece.nil? and valid_moves.include?(coord)
    return false
  end

  def in_bounds?(coord)
    return false if coord[0] < 0 or coord[0] > 7
    return false if coord[1] < 0 or coord[1] > 7
    true
  end

  def end_of_board?
    return true if @color == :W and @position[0] == 0
    return true if @color == :B and @position[0] == 7
    false
  end

  def king_me
    @board.board[@position[0]][@position[1]] =
        King.new(@color, @position, @board)
  end
end

class King < Piece
  def initialize(color, position, board)
    super(color, position, board)
    @valid_trans = [ [1,-1],[1,1],[-1,-1],[-1,1] ]
    @valid_jump_trans = [ [2,-2], [2,2], [-2,-2], [-2,2] ]
  end
end

class WhiteSquare
end