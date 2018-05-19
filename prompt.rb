module Prompt
  # answers can be a Regexp or an Array
  def prompt(question, answers)
    loop do
      print question
      response = gets.chop
      return response if answers.is_a?(Regexp) && response.match(answers)
      return response if answers.is_a?(Array) && answers.include?(response)
      puts "Invalid input. Please try again"
    end
  end
end
