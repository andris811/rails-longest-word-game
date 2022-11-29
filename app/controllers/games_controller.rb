require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (("A".."Z").to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = (params[:word] || "").upcase
    @letters = params[:letters].split
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)

    # raise
    # if @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    #   if english_word?(params[:word])
    #     @answer = "The word is valid according to the grid and is an English word"
    #   else
    #     @answer = "The word is valid according to the grid, but is not a valid English word"
    #   end
    # else
    #   @answer = "Can't be build from the original grid"
    # end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
