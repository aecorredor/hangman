require 'pstore'

module Hangman
  # implements game loop with menus and ability to save and load game
  # by using ruby's PStore for object persistence
  class Game
    attr_accessor :playing_word

    def initialize(file_name)
      @playing_word = Word.new(file_name)
    end

    # saves Word object containing all game info using ruby's PStore
    def save_game
      store = PStore.new('data.pstore')
      store.transaction do
        store[:saved_game] = @playing_word
      end
      puts 'Game saved successfully!'
    end

    # loads Word object and resumes game loop with start_game method
    def load_game
      if File.exist?('data.pstore')
        store = PStore.new('data.pstore')
        store.transaction do
          @playing_word = store[:saved_game]
        end
        puts 'Game loaded successfully!'
        start_game
      else
        puts 'No saved game found.'
        puts ''
      end
    end

    def play
      loop do
        display_main_menu
        user_choice = gets.chomp
        puts ''
        if user_choice == '1'
          # new game logic here
          start_game
          return
        elsif user_choice == '2'
          # load game logic here
          load_game
          return
        elsif user_choice == '3'
          puts 'exiting game...'
          return
        else
          puts 'wrong choice, select valid option'
        end
      end
    end

    def display_main_menu
      puts 'Welcome to Hangman'
      puts 'Main menu: '
      puts '  1) New game'
      puts '  2) Load game'
      puts '  3) Exit game'
      print 'Choose option (1, 2, 3): '
    end

    def display_game_menu
      puts 'Game menu:'
      @playing_word.display_word
      @playing_word.display_incorrect_guesses
      puts ''
      @playing_word.display_remaining_guesses
      puts ''
      puts '  1) Make guess'
      puts '  2) Save game and exit'
      print 'Choose option (1, 2): '
    end

    def start_game
      loop do
        display_game_menu
        user_choice = gets.chomp
        puts ''
        if user_choice == '1'
          # user chooses to guess
          guess
          return if game_over?
        elsif user_choice == '2'
          # user chooses to save game
          save_game
          return
        else
          puts 'wrong choice, select valid option'
        end
      end
    end

    def guess
      print 'Choose letter to guess: '
      guessed_letter = gets.chomp
      puts ''
      if @playing_word.correct_guess?(guessed_letter)
        @playing_word.reveal_letter(guessed_letter)
      else
        @playing_word.add_incorrect_guess(guessed_letter)
      end
    end

    def game_over?
      if @playing_word.win?
        puts "You guessed the correct word: #{@playing_word.word_selected}"
        puts 'You won!'
        return true
      elsif @playing_word.lost?
        puts 'You lost, better luck next time!'
        puts "The word was #{@playing_word.word_selected}"
        return true
      end
      false
    end
  end
end
