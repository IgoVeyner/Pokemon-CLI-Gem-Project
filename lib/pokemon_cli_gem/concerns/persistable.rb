module Persistable
  module ClassMethods

    # Assigns @@all class variable
    def self.extended(base)
      base.class_variable_set(:@@all, [])
    end
    
    # Creates reader for @@all
    def all
      class_variable_get(:@@all)
    end
    
    def create(name)
      new(name).tap{|o| o.save}
    end
  end
  
  module InstanceMethods
    def initialize(name)
      @name = name
    end

    def save
      self.class.all << self
    end
  end
end