require_relative 'lib/pokemon_cli_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "pokemon_cli_gem"
  spec.version       = PokemonCliGem::VERSION
  spec.authors       = ["IgoVeyner"]
  spec.email         = ["igorveyner95@gmail.com"]

  spec.summary       = %q{Pokemon CLI Gem Project}
  spec.description   = %q{Pokemon CLI Gem Project for Flatiron School Software Engineering program}
  spec.homepage      = "https://github.com/IgoVeyner/Pokemon-CLI-Gem-Project"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://github.com/IgoVeyner/Pokemon-CLI-Gem-Project"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/IgoVeyner/Pokemon-CLI-Gem-Project"
  spec.metadata["changelog_uri"] = "https://github.com/IgoVeyner/Pokemon-CLI-Gem-Project/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
