class HangmanGame
  INCORRECT_GUESS_LIMIT = 6
  
  attr_reader :guesses, :win, :lose
  
  def initialize
    @win = false
    @lose = false
    @word = random_word
    @incorrect_guesses = 0
    @guessed_letters = []
    @progress = Array.new(@word.length)
  end
  
  def to_s
    result = ""
    
    progress_string = @progress.map do |letter|
      if letter
        letter
      else
        "_"
      end
    end
    result += progress_string.join(" ") + "\n"
    
    guesses_left = INCORRECT_GUESS_LIMIT - @incorrect_guesses
    result + "Incorrect guesses left: #{guesses_left}"
  end
  
  def guess(guess_letter)
    guess_letter.upcase!
    return false if @guessed_letters.include?(guess_letter)
    
    if @word.include?(guess_letter)
      @word.split("").each_with_index do |letter, i| 
        @progress[i] = guess_letter if letter == guess_letter
      end
    else
      @incorrect_guesses += 1
    end
    
    check_game_end
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
      win = true
    elsif @incorrect_guesses >= INCORRECT_GUESS_LIMIT
      lose = true
    end
  end
    
    
  
  def win
  end
end