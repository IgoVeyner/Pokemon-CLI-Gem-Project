require_relative "./pokemon_cli_gem/version"

module PokemonCliGem
  class Error < StandardError; end
  # Your code goes here...
end

# Utilities
require "net/http"
require "json"
require "require_all"
require "colorize"

# Libraries
require_all './lib'
