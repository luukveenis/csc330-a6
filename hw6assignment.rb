# Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece

  All_My_Pieces = All_Pieces + [[[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],
                                [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]],
                                rotations([[0, 0], [0, 1], [1, 0]]),
                                rotations([[0, 0], [1, 0], [2, 0], [0, 1], [1, 1]])]

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
  end

  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
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
  end
end
