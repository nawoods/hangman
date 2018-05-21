require 'yaml'

class HangmanGame
  INCORRECT_GUESS_LIMIT = 6
  
  attr_reader :incorrect_letters, :win, :lose

  def self.from_yaml(string)
    data = YAML.load(string)
    self.new(data[:word], data[:incorrect_letters], 
             data[:guessed_letters], data[:progress])
  end

  def initialize(word = nil, incorrect_letters = nil, 
                 guessed_letters = nil, progress = nil)
    @win = false
    @lose = false
    @word ||= random_word
    @incorrect_letters ||= []
    @guessed_letters ||= []
    @progress ||= Array.new(@word.length)
  end

  def to_yaml
    YAML.dump ({
      :word => @word,
      :incorrect_letters => @incorrect_letters,
      :guessed_letters => @guessed_letters,
      :progress => @progress
    })
  end
  
  def to_s
    result = ""

    result += hangman_ascii(@incorrect_letters.length)
    
    progress_string = @progress.map do |letter|
      if letter
        letter
      else
        "_"
      end
    end
    result += progress_string.join(" ") + "\n"
    
    guesses_left = INCORRECT_GUESS_LIMIT - @incorrect_letters.length
    result += "Incorrect letters: #{incorrect_letters.join(", ")}\n"
    result += "Incorrect guesses left: #{guesses_left}"
  end
  
  def guess(guess_letter)
    guess_letter.upcase!
    return false if @guessed_letters.include?(guess_letter)
    @guessed_letters << guess_letter
    
    if @word.include?(guess_letter)
      @word.split("").each_with_index do |letter, i| 
        @progress[i] = guess_letter if letter == guess_letter
      end
    else
      @incorrect_letters << guess_letter
    end
    
    check_game_end
  end

  def word
    return unless @lose
    @word
  end

  def first_turn?
    return @guessed_letters.length == 0
  end
  
  private
  
  def random_word
    f = File.open("5desk.txt", "r")
    words = f.readlines
    f.close
    
    words.map! { |word| word.chomp }
    words.select! { |word| word.length > 4 && word.length < 13 }
    words.sample.upcase
  end
  
  def check_game_end
    if @progress.all?
      @win = true
    elsif @incorrect_letters.length >= INCORRECT_GUESS_LIMIT
      @lose = true
    end
  end

  def hangman_ascii(num)
    result = ""
    f = File.open("ascii/ascii_hangman#{num}.txt", "r")
    result << f.read
    f.close
    result
  end
end
