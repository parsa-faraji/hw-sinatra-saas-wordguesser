class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  # Initialize a new game with a word
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Process one guessed letter
  def guess(letter)
    raise ArgumentError if letter.nil?
    raise ArgumentError if letter.empty?
    raise ArgumentError unless letter =~ /^[A-Za-z]$/

    letter = letter.downcase

    # Repeated guesses are invalid but should not crash
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end

    true
  end

  # Return the word with unguessed letters replaced by -
  def word_with_guesses
    @word.chars.map do |letter|
      if @guesses.include?(letter)
        letter
      else
        '-'
      end
    end.join
  end

  # Return :win, :lose, or :play
  def check_win_or_lose
    if word_with_guesses == @word
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  # Get a word from remote "random word" service
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end