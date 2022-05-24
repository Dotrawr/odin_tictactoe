# frozen_string_literal: true

# Game class handles the game state
class Game
  attr_accessor :board, :symbols

  def initialize
    @players = []
    @board = Array.new(9) { |i| i + 1 } # generate an array to represent the board with the numbers 1-9 in the spaces
    @current_player = rand(0..1) # used randomly choose the current player
    @symbols = %w[X O].shuffle # the symbols to distinguish one player from the other
  end

  def start
    number_of_players = nil
    winner_or_draw = false
    puts 'Welcome to Tic Tac Toe!'
    # loop until a number between 0 - 2 is entered to get how many people will play
    until number_of_players.to_i.to_s == number_of_players && number_of_players.to_i <= 2 && number_of_players.to_i >= 0
      print 'How many human players? (0, 1, 2): '
      number_of_players = gets.chomp
    end
    create_players(number_of_players.to_i) # create normal and computer players based on the number entered
    winner_or_draw = play_a_round while winner_or_draw == false # play rounds until win or draw
    draw_board # draw the board to the terminal
    puts winner_or_draw.to_s # show the winner or draw
  end

  def create_players(number_of_players)
    computer_players = 2 - number_of_players
    create_human_players(number_of_players) if number_of_players.positive?
    create_computer_players(computer_players) if computer_players.positive?
  end

  def create_human_players(number_of_humans)
    number_of_humans.times do
      name = ''
      while name == ''
        print 'Please enter a name: '
        name = gets.chomp
      end
      symbol = @symbols.pop # pop a symbol to ensure it's unique
      @players.push(HumanPlayer.new(name, symbol))
    end
  end

  def create_computer_players(number_of_computers)
    number_of_computers.times do
      symbol = @symbols.pop # pop a symbol to ensure it's unique
      @players.push(ComputerPlayer.new("Computer #{@players.length + 1}", symbol))
    end
  end

  def draw_board
    print "   #{@board[0]} | #{@board[1]} | #{@board[2]}
   --|---|--
   #{@board[3]} | #{@board[4]} | #{@board[5]}
   --|---|--
   #{@board[6]} | #{@board[7]} | #{@board[8]}\n"
  end

  def play_a_round
    current_player = @players[@current_player] # set current player
    draw_board
    play_move(current_player)
    # swap current player for next round
    @current_player = if @current_player.positive?
                        0
                      else
                        1
                      end
    check_winner(current_player)
  end

  def play_move(current_player)
    move = nil
    move = current_player.play while move.nil? || valid_move?(move) == false # validate move and loop until we get one
    @board[move - 1] = current_player.symbol # update the board with a player symbol
    puts "#{current_player.name} has just played position #{move}"
  end

  def valid_move?(move)
    if move.nil?
      false
    else
      @board[move - 1] == move # checking if there's a symbol already
    end
  end

  def check_winner(current_player)
    winning_lines = [
      [@board[0], @board[1], @board[2]],
      [@board[3], @board[4], @board[5]],
      [@board[6], @board[7], @board[8]],
      [@board[0], @board[3], @board[6]],
      [@board[1], @board[4], @board[7]],
      [@board[2], @board[5], @board[8]],
      [@board[0], @board[4], @board[8]],
      [@board[2], @board[4], @board[6]]
    ]
    return "#{current_player.name} has won the game." if winning_lines.any?(%w[X X
                                                                               X]) || winning_lines.any?(%w[O O
                                                                                                            O])

    return 'DRAW!' if @board.none?(Integer)

    false
  end
end
