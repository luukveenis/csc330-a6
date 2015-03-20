# Programming Languages, Homework 6, hw6runner.rb

class MyPiece < Piece

  All_My_Pieces = All_Pieces + [[[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],
                                [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]],
                                rotations([[0, 0], [0, 1], [1, 0]]),
                                rotations([[0, 0], [0, 1], [0, 2], [1, 0], [1, 1]])]

  def self.next_piece(board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
end

class MyBoard < Board

  def initialize (game)
    @grid = Array.new(num_rows) { Array.new(num_columns) }
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @cheat = false
  end

  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def next_piece
    if @cheat
      @current_block = MyPiece.new([[0,0]], self)
      @cheat = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # Overrides superclass method
  # Uses locations.size instead of hardcoded range, since original
  # assumed all pieces were made up of 4 blocks
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each do |index|
      current = locations[index]
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
        @current_pos[index]
    end
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # Pay 100 points to get a 1x1 block
  def cheat
    if @score > 100 && !@cheat
      @score = @score - 100
      @cheat = true
    end
  end
end

class MyTetris < Tetris

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', ->{ @board.rotate_180 })
    @root.bind('c', ->{ @board.cheat })
  end
end
