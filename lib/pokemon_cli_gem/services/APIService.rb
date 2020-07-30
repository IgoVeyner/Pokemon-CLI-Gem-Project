class APIService
  
  attr_accessor :current_response, :search_history

  BASE_URI = "https://pokeapi.co/api/v2/"
  Spacer = "-------------------------------------------------------------".colorize(:yellow)

  def initialize
    @search_history = []
  end


  # Custom find / create method
  def find_or_create_search_request(user_input, search_type)
    puts Spacer
    puts "Checking search history....".colorize(:light_black)

    prev_search = find_prev_search(user_input, search_type)
    if prev_search
      puts Spacer
      puts "Found it!".colorize(:light_green)
      @current_response = prev_search[:response]
    else
      puts Spacer
      puts "Not there...".colorize(:red)
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

    puts Spacer
    puts "Searching API... Please Wait...".colorize(:light_black)

    @current_response = Net::HTTP.get_response(uri)
    save_search(user_input, search_type)
  end


  # Makes a new hash, saves the data from a search and adds it into search history
  def save_search(user_input, search_type)
    Hash.new.tap do |h|
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
    parsed = JSON.parse(@current_response.body)
    Pokemon.find_or_create_by_name(parsed["name"]).tap do |p|
      p.height = parsed["height"]
      p.weight = parsed["weight"]
      p.pokedex_entry = read_pokedex_entry(parsed["species"]["url"])
      parsed["types"].each_with_index do |type, i|
        name = type["type"]["name"]
        p.types_array[i] = Type.find_or_create_through_pokemon_search(name, p)
      end
      print p.pretty_text
    end
  end
  
  
  # Pokedex entries require another API request from a supplied url
  # Grabs the english text and removes unessesary page break
  def read_pokedex_entry(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    parsed = JSON.parse(response.body)
    english_text = parsed["flavor_text_entries"].find{|a| a["language"]["name"] == "en"}
    english_text["flavor_text"].gsub("\f", " ")
  end

  
  # Reads type response and instantiates new Type / Pokemon instances from data.
  # Then prints all the Pokemon that belong to the Type
  def read_type_response
    parsed = JSON.parse(@current_response.body)
    type = Type.find_or_create_by_name(parsed["name"])
    parsed["pokemon"].each do |pokemon|
      name = pokemon["pokemon"]["name"]
      pokemon = Pokemon.find_or_create_by_name(name)
      pokemon.types_array << type unless pokemon.types_array.include?(type)
      type.pokemon_array << pokemon unless type.pokemon_array.include?(pokemon)
    end
    type.print_all
  end
end