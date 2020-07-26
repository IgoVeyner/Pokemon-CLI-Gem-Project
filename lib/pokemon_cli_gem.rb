require_relative "./pokemon_cli_gem/version"

module PokemonCliGem
  class Error < StandardError; end
  # Your code goes here...
end

# Utilities
require "open-uri"
require "net/http"
require "json"
require "require_all"
require "colorize"

require 'pry' #take out before publishing

# Libraries
require_all './lib'
