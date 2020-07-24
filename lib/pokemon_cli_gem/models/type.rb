class Type 
  attr_reader :name
  attr_accessor :pokemon

  @@all = []
  
  def initialize(name)
    @name = name
    @pokemon = []
  end
  
  def save
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.create(name)
    new(name).tap{|o| o.save}
  end

  def self.find_by_name(name)
    self.all.find {|p| p.name == name}
  end

  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(name)
  end

  def self.find_or_create_through_pokemon(name, pokemon_instance)
    self.find_or_create_by_name(name).tap {|o| o.pokemon << pokemon_instance}
  end
end