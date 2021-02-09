class Cell
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

class Board
  attr_accessor :cells

  def initialize
    @cells = Array.new(9) { |index| Cell.new(index + 1) }
  end

  def print_board
    puts "
 #{cells[0].value}  | #{cells[1].value}  | #{cells[2].value}
----+----+----
 #{cells[3].value}  | #{cells[4].value}  | #{cells[5].value}
----+----+----
 #{cells[6].value}  | #{cells[7].value}  | #{cells[8].value}
"
  end

  def free_positions
    cells.select { |cell| cell.value.is_a? Integer }
  end

  def place_marker(location, marker)
    cells[location - 1].value = marker
  end
end

class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

class Game
  attr_reader :board
  attr_accessor :players, :current_play_index

  LINES = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
  def initialize
    @board = Board.new
    @players = []
    @current_play_index = 0
  end

  def start_game
    setup_players
    @board.print_board
  end

  def setup_players
    self.players = []
    print 'Player 1 Enter your name: '
    players.push(Player.new(gets.chomp, 'X'))
    print 'Player 2 Enter your name: '
    players.push(Player.new(gets.chomp, 'O'))
  end

  def play
    loop do
      player_make_move
      board.print_board
      if player_won?
        puts "#{@players[@current_play_index].name} WON!!!"
        break
      elsif board_full?
        puts "It's a Tie!"
        break
      end
      switch_player
    end
  end

  def switch_player
    self.current_play_index = 1 - current_play_index.to_i
  end

  def player_make_move
    marker = nil
    loop do
      p "#{@players[@current_play_index].name} please select one tile: "
      marker = gets.chomp.to_i
      if !marker.between?(1, 9)
        puts 'Out of range number'
      elsif board.free_positions.none? { |cell| marker == cell.value }
        puts 'That place is occupied'
      end
      break if marker.between?(1, 9) && board.free_positions.any? { |cell| marker == cell.value }
    end
    board.place_marker(marker, @players[@current_play_index].symbol)
  end

  def player_won?
    LINES.any? do |line|
      line.all? { |position| board.cells[position].value == @players[@current_play_index].symbol }
    end
  end

  def board_full?
    true if board.free_positions.empty?
  end
end

def play_game
  game = Game.new
  game.start_game
  game.play
  play_again
end

def play_again
  puts 'Do you want to play again? (y/n)'
  answer = gets.chomp.downcase
  play_game if %w[y yes].include?(answer)
end

play_game
