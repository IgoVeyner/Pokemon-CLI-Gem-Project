class Type 
  extend Findable::ClassMethods
  extend Persistable::ClassMethods
  include Persistable::InstanceMethods

  attr_reader :name
  attr_accessor :pokemon
  
  def initialize(name)
    super(name)
    @pokemon = []
  end

  # Finds or creates new Pokemon instances and saves it
  def self.find_or_create_through_pokemon_search(name, pokemon_instance)
    self.find_or_create_by_name(name).tap {|o| o.pokemon << pokemon_instance unless o.pokemon.include?(pokemon_instance)}
  end

  # Prints all the pokemon that belong to the current type instance
  def print_all
    self.pokemon.each.with_index(1) {|p,i| puts "#{i}. #{p.name}"}
  end
end