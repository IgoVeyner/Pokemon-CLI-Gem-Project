class APIService
  
  BASE_URI = "https://pokeapi.co/api/v2/"

  def make_request(name_or_type, user_input)
    uri = URI(BASE_URI + "#{name_or_type}/#{user_input}/")
    response = Net::HTTP.get_response(uri)
  end

  def read_pokemon_response(response)
    search = JSON.parse(response.body)
    name = search["name"]
    Pokemon.find_or_create_by_name(name).tap do |p|
      p.height = search["height"]
      p.weight = search["weight"]
      p.type1 = Type.find_or_create_through_pokemon(search["types"][0]["type"]["name"], p)
      p.type2 = Type.find_or_create_through_pokemon(search["types"][1]["type"]["name"], p) if search["types"][1]
      p.pokedex_entry = read_pokedex_entry(search["species"]["url"])
    end
  end
  
  def read_pokedex_entry(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    search = JSON.parse(response.body)
    english_text = search["flavor_text_entries"].find{|a| a["language"]["name"] == "en"}
    english_text["flavor_text"].gsub("\f", " ")
  end
end