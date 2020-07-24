class Pokemon
  attr_accessor :name, :height, :weight, :type1, :type2, :pokedex_entry

  @@all = []

  def initialize(name)
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

  def pretty_text
    puts "#{self.name.capitalize}\n"
    print "Type: #{self.type1.name.capitalize}" 
    print "/#{self.type2.name.capitalize}" if self.type2 
    print "\n"
    puts "\n#{pokedex_entry}"
    puts "\nHeight: #{(height *  3.937).round(2)} in / #{(height * 0.1).round(2)} m"
    puts "Weight: #{(weight / 4.536).round(1)} lb / #{(weight * 0.1).round(2)} kg"
  end
end