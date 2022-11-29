require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10){[*"A".."Z"].to_a.sample}
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    # raise
    if @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
      if english_word?(params[:word])
        @answer = "The word is valid according to the grid and is an English word"
      else
        @answer = "The word is valid according to the grid, but is not a valid English word"
      end
    else
      @answer = "Can't be build from the original grid"
    end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
