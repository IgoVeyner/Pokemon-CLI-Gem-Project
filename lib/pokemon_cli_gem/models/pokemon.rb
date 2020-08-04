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
end