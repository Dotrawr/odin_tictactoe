# frozen_string_literal: true

# Player class handles both human and computer players
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

# This class handles Human players.
class HumanPlayer < Player
  def play
    move = nil
    until move.to_i.to_s == move # verify input is a number and loop until it is a number
      puts "#{@name}'s turn."
      puts 'Where would you like to go? Enter a number: '
      move = gets.chomp # get user input for their move.
    end
    move.to_i # return the move as an int
  end
end

# This class handles Computer players.
class ComputerPlayer < Player
  def play
    rand(1..9) # Play a random move.
  end
end
