# PokemonCliGem

Welcome to the Pokemon_Cli_gem.

This CLI Gem allows you to look up Pokemon by their name or Pokedex number or look up all the Pokemon that are of a type.

Pokemon searches will display their name, type(s), pokedex entry, height and weight.
Type searches will display all the pokemon of the type including variations. So if you search for Ice, ninetales-alola will be included as the alola variation of ninetales is an ice type.

From the type search you can look up more info on those pokemon by entering its number on the list.

Hope you enjoy and please let me know if you would like a feature included.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pokemon_cli_gem'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pokemon_cli_gem

## Usage

This is a CLI gem, just enter

./bin/pokemon_cli_gem

into bash

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/IgoVeyner/pokemon_cli_gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/IgoVeyner/pokemon_cli_gem/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PokemonCliGem project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/IgoVeyner/pokemon_cli_gem/blob/master/CODE_OF_CONDUCT.md).
