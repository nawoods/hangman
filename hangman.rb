require "./hangman_game"
require "./prompt"

class Hangman
  include Prompt

  def initialize
    puts "W E L C O M E   T O   H A N G M A N"
    puts "\"Weirdly macabre for a children's game\""

    @game = HangmanGame.new

    loop { break if turn }
  end

  private

  def turn
    puts @game
    @game.guess(prompt("Please enter a letter: ", /^[a-z]$/i))
    win if @game.win
    lose if @game.lose
    @game.win || @game.lose
  end

  def win
    puts @game
    puts "You won!"
  end

  def lose
    puts @game
    puts "You lost! The word was: #{@game.word}"
  end
end

Hangman.new
