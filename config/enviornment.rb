# Gems / Utilities
require "pry"
require "colorize"
require "uri"
require "net/http"
require "json"

# Classes
require_relative "../lib/pokemon_cli_gem/concerns/persistable.rb"
require_relative "../lib/pokemon_cli_gem/concerns/findable.rb"
require_relative "../lib/pokemon_cli_gem/models/pokemon.rb"
require_relative "../lib/pokemon_cli_gem/models/type.rb"
require_relative "../lib/pokemon_cli_gem/services/APIService.rb"
require_relative "../lib/CLI.rb"