class Pokemon

  attr_accessor :name, :pokedex_number, :height, :weight, :type, :pokedex_entry

  @@all = []

  def initialize(name, pokedex_number = nil, height = nil, type = nil, weight = nil, pokedex_entry = nil) #refactor with mass assignment later
    @name = name
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