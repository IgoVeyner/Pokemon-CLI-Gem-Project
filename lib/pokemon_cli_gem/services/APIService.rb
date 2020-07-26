class APIService
  
  attr_accessor :current_response, :search_history

  BASE_URI = "https://pokeapi.co/api/v2/"

  def initialize
    @search_history = []
  end

  # Custom find / create method
  def find_or_create_search_request(user_input, search_type)
    if find_prev_search(user_input, search_type)
      @current_response = self.search_history.find {|h| h[:input] == user_input && h[:search_type] == search_type}[:response]
    else 
      create_request(user_input, search_type)
    end
  end
  
  # Looks inside search history array of hashes
  def find_prev_search(user_input, search_type)
    self.search_history.find {|h| h[:input] == user_input && h[:search_type] == search_type}
  end

  # Creates a new request and saves it into search history array
  def create_request(user_input, search_type)
    uri = URI(BASE_URI + "#{search_type}/#{user_input}/")
    @current_response = Net::HTTP.get_response(uri)
    save_search(user_input, search_type)
  end
  
  
  # not sure if individual request methods are better (more flexible) than a blanket request method... 
    # def find_or_create_search_request(user_input, search_type)
    #   if find_prev_search(user_input, search_type)
    #     @current_response = self.search_history.find {|h| h[:input] == user_input && h[:search_type] == search_type}[:response]
    #   else 
    #     make_pokemon_search_request(user_input) if search_type = "pokemon"
    #     make_type_search_request(user_input) if search_type = "type"
    #     create_request(user_input, search_type)
    #   end
    # end
  
    # def make_pokemon_search_request(user_input)
    #   uri = URI(BASE_URI + "pokemon/#{user_input}/")
    #   @current_response = Net::HTTP.get_response(uri)
    #   save_search(user_input, "pokemon")
    # end

    # def make_type_search_request(user_input)
    #   uri = URI(BASE_URI + "type/#{user_input}/")
    #   @current_response = Net::HTTP.get_response(uri)
    #   save_search(user_input, "type")
    # end

  # Makes a new hash, saves the data from a search and adds it into search history
  def save_search(user_input, search_type)
    search_hash = Hash.new.tap do |h|
      h[:input] = user_input
      h[:search_type] = search_type
      h[:response] = @current_response
      @search_history << h 
    end
  end

  # Checks to see if the response was successful
  def valid_response?
    @current_response.is_a?(Net::HTTPSuccess)
  end

  # Parses pokemon search response, instatiates new Pokemon & Type instances and prints out that Pokemon's data
  def read_pokemon_response
    search = JSON.parse(@current_response.body)
    Pokemon.find_or_create_by_name(search["name"]).tap do |p|
      p.height = search["height"]
      p.weight = search["weight"]
      p.type1 = search["types"][0]["type"]["name"]
      p.type2 = search["types"][1]["type"]["name"] if search["types"][1]
      p.pokedex_entry = read_pokedex_entry(search["species"]["url"])
      search["types"].each do |type|
        name = type["type"]["name"]
        p.types << Type.find_or_create_through_pokemon_search(name, p) unless p.types.include?(Type.find_by_name(name))
      end
      print p.pretty_text
    end
  end
  
  # Pokedex entries require another API request from a supplied url
  # Grabs the english text and removes unessesary page break
  def read_pokedex_entry(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    search = JSON.parse(response.body)
    english_text = search["flavor_text_entries"].find{|a| a["language"]["name"] == "en"}
    english_text["flavor_text"].gsub("\f", " ")
  end

  # Reads type response and instantiates new Type / Pokemon instances from data.
  # Then prints all the Pokemon that belong to the Type
  def read_type_response
    search = JSON.parse(@current_response.body)
    Type.find_or_create_by_name(search["name"]).tap do |type_instance|
      search["pokemon"].each do |pokemon|
        name = pokemon["pokemon"]["name"]
        Pokemon.find_or_create_by_name(name).tap do |pokemon_instance| 
          pokemon_instance.types << type_instance unless pokemon_instance.types.include?(type_instance)
          type_instance.pokemon << pokemon_instance unless type_instance.pokemon.include?(pokemon_instance)
        end
      end
      type_instance.print_all
    end
  end
end