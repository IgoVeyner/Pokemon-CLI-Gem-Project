class APIService
  
  BASE_URI = "https://pokeapi.co/api/v2/"

  def make_request(name_or_type, user_search_input)
    uri = URI(BASE_URI + "#{name_or_type}/#{user_search_input}/")
    response = Net::HTTP.get_response(uri)
  end

  def read_pokemon_response(response)
    search = JSON.parse(response.body)
    Pokemon.find_or_create_by_name(search["name"]).tap do |p|
      p.height = search["height"]
      p.weight = search["weight"]
      p.type1 = search["types"][0]["type"]["name"]
      p.type2 = search["types"][1]["type"]["name"] if search["types"][1]
      p.pokedex_entry = read_pokedex_entry(search["species"]["url"])
      search["types"].each do |type|
        p.types << Type.find_or_create_through_pokemon_search(type["type"]["name"], p)
      end
      puts p.pretty_text
    end
  end
  
  def read_pokedex_entry(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    search = JSON.parse(response.body)
    english_text = search["flavor_text_entries"].find{|a| a["language"]["name"] == "en"}
    english_text["flavor_text"].gsub("\f", " ")
  end

  def read_type_response(response)
    search = JSON.parse(response.body)
    Type.find_or_create_by_name(search["name"]).tap do |type_instance|
      search["pokemon"].each do |pokemon| 
        Pokemon.find_or_create_by_name(pokemon["pokemon"]["name"]).tap do |pokemon_instance| 
          pokemon_instance.types << type_instance
          type_instance.pokemon << pokemon_instance
        end
      end
      type_instance.print_all
    end
  end
end