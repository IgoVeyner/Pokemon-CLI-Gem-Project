class Pokemon
  extend Findable::ClassMethods
  extend Persistable::ClassMethods
  include Persistable::InstanceMethods

  attr_reader :name
  attr_accessor :height, :weight, :types_array, :pokedex_entry

  def initialize(name)
    super(name)
    @types_array = []
  end

  # Prints the Pokemon's data, nice and pretty
  def pretty_text
    puts "#{self.name.capitalize}\n"
    print "Type: #{self.types_array[0].name.capitalize}" 
    print "/#{self.types_array[1].name.capitalize}" if self.types_array[1] 
    puts ""
    puts "\n#{pokedex_entry}"
    puts "\nHeight: #{(height *  3.937).round(2)} in / #{(height * 0.1).round(2)} m"
    puts "Weight: #{(weight / 4.536).round(1)} lb / #{(weight * 0.1).round(2)} kg"
  end
end