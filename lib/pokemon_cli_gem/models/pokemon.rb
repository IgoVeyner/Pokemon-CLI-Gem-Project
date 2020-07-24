class Pokemon

  attr_accessor :name, :pokedex_number, :height, :weight, :type, :pokedex_entry

  @@all = []

  #get rid of all but name
  def initialize(name, pokedex_number = nil, height = nil, weight = nil, type = nil, pokedex_entry = nil) #refactor with mass assignment later
    @name = name
    @pokedex_number = pokedex_number if pokedex_number
    @height = height if height
    @weight = weight if weight
    @type if type
    @pokedex_entry = pokedex_entry if pokedex_entry
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
end