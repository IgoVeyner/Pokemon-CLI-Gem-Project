class Type 
  extend Findable::ClassMethods
  extend Persistable::ClassMethods
  include Persistable::InstanceMethods

  attr_reader :name
  attr_accessor :pokemon_array
  
  def initialize(name)
    super(name)
    @pokemon_array = []
  end

  # Finds or creates new Pokemon instances and saves it
  def self.find_or_create_through_pokemon_search(name, pokemon_instance)
    self.find_or_create_by_name(name).tap {|o| o.pokemon_array << pokemon_instance unless o.pokemon_array.include?(pokemon_instance)}
  end
end