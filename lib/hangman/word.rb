module Hangman
  # Word class represents the word that the user has to guess
  # contains all the functionality for checking user's guesses
  # and displaying the word to the user
  class Word
    attr_reader :words_loaded, :word_selected
    attr_accessor :hidden_word, :wrong_guesses, :current_wrong_guesses

    # creates the word object with a .txt file that has a word on each line
    def initialize(file_name)
      @words_loaded = load_words(file_name)
      @word_selected = select_word(@words_loaded)
      @hidden_word = hide_word(@word_selected)
      @correct_guesses = []
      @wrong_guesses = []
      @max_wrong_guesses = 10
      @current_wrong_guesses = 0
    end

    # display current word to player with its current status, meaning
    # that it shows '_' for letters still not guessed
    def display_word
      puts "Current word: #{@hidden_word}"
    end

    # checks to see if guess of letter was correct
    def correct_guess?(letter)
      if @word_selected.include?(letter)
        if @correct_guesses.empty?
          @correct_guesses << letter
        elsif @correct_guesses.include?(letter)
          puts 'Letter already guessed! try another one!'
        else
          @correct_guesses << letter
        end
        return true
      end
      false
    end

    # adds an incorrect guess to the @wrong_guesses instance variable array
    def add_incorrect_guess(letter)
      if @wrong_guesses.empty?
        @wrong_guesses << letter
        @current_wrong_guesses += 1
      elsif @wrong_guesses.include?(letter)
        puts 'Letter already guessed! try another one!'
      else
        @wrong_guesses << letter
        @current_wrong_guesses += 1
      end
    end

    # displays a list of the incorrected guesses to the user
    def display_incorrect_guesses
      if @wrong_guesses.empty?
        puts 'No wrong guesses so far.'
      else
        print 'Wrong guesses: '
        @wrong_guesses.each do |letter|
          print "#{letter} "
        end
      end
    end

    def display_remaining_guesses
      puts "Remaining guesses: #{@max_wrong_guesses - @current_wrong_guesses}"
    end

    # changes '_' for the corresponding letter if player's guess was correct
    def reveal_letter(letter_guessed)
      @word_selected.split('').each_with_index do |letter, index|
        @hidden_word[index] = letter_guessed if letter_guessed == letter
      end
    end

    # checks if player won
    def win?
      !@hidden_word.include?('_')
    end

    # checks if player lost
    def lost?
      @current_wrong_guesses == @max_wrong_guesses
    end

    private

    # loads words with length between 5 and 12 from a .txt file into an array
    # assumes that each word is in a separate line
    def load_words(file_name)
      words_loaded = []
      File.open(file_name).readlines.each do |line|
        words_loaded << line if line.length.between?(5, 12)
      end
      words_loaded
    end

    # selects a random word from an array with arbitraty length
    def select_word(words)
      word_selected = words[rand(words.length)].strip
      word_selected
    end

    # hides the selected word by replacing letters with '_'
    def hide_word(word)
      word.split('').map { '_' }.join
    end
  end
end
