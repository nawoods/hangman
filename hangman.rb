require "./hangman_game"
require "./prompt"

class Hangman
  include Prompt

  def initialize
    puts "W E L C O M E   T O   H A N G M A N"
    puts "\"Weirdly macabre for a children's game\""

    loop do
      cli_game
      break if prompt("Play again? (y/n) ", /^[yn]/i) =~ /^n/i
    end
  end

  private

  def cli_game
    @game = nil
    start_game
    loop { break if turn }
    win if @game.win
    lose if @game.lose
  end

  def start_game
    question = "Would you like to load a previously saved game? (y/n): "
    loop do
      break if @game || prompt(question, /^[yn]/i) =~ /^n/i
      @game = load_game
    end
    @game ||= HangmanGame.new
  end

  def turn
    puts @game 
    save_game_request
    @game.guess(prompt("Please enter a letter: ", /^[a-z]$/i))
    @game.win || @game.lose
  end

  def save_game_request
    return if @game.first_turn?
    loop do
      break if prompt("Save game? (y/n): ", /^[yn]/i) =~ /^n/i || save_game
    end
  end

  def save_game
    filepath = prompt("Please enter filename: ", /^[^\/\\]+$/)
    if File.exist?(filepath)
      response = prompt("File already exists. Overwrite? (y/n)", /^[yn]/i)
      return if response =~ /^n/i
    end

    yaml_string = @game.to_yaml
    File.open(filepath, 'w') { |f| f.write yaml_string }
    true
  end

  def load_game
    filepath = prompt("Please enter filename: ", /^[^\/\\]+$/)
    unless File.exist?(filepath)
      puts "File not found!"
      return
    end
    f = File.open(filepath, 'r')
    result = f.read
    f.close
    HangmanGame.from_yaml(result)
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
