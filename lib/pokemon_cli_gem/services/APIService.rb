class APIService
  
  attr_accessor :response

  BASE_URI = "https://pokeapi.co/api/v2/"

  def make_pokemon_search_request(user_input)
    uri = URI(BASE_URI + "pokemon/#{user_input}/")
    @response = Net::HTTP.get_response(uri)
  end

  def make_type_search_request(user_input)
    uri = URI(BASE_URI + "type/#{user_input}/")
    @response = Net::HTTP.get_response(uri)
  end

  def valid_response?
    @response.is_a?(Net::HTTPSuccess)
  end

  def read_pokemon_response
    search = JSON.parse(@response.body)
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
  
  def read_pokedex_entry(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    search = JSON.parse(response.body)
    english_text = search["flavor_text_entries"].find{|a| a["language"]["name"] == "en"}
    english_text["flavor_text"].gsub("\f", " ")
  end

  def read_type_response
    search = JSON.parse(@response.body)
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