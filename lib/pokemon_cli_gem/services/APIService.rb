class APIService
  
  BASE_URI = "https://pokeapi.co/api/v2/"
  
  def initialize
    
  end

  def make_request(name_or_type, user_input)
    uri = URI(BASE_URI + "#{name_or_type}/#{user_input}/")
    response = Net::HTTP.get_response(uri)
  end

  def read_pokemon_response(response)
    search = JSON.parse(response.body)
    name = search["name"]
    Pokemon.find_or_create_by_name(name).tap do |p|
      p.pokedex_number = search["order"]
      p.height = search["height"]
      p.weight = search["weight"]
      p.type = "Stub"
      p.pokedex_entry = read_pokedex_entry(search["species"]["url"])
    end
  end

  def read_pokedex_entry(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    search = JSON.parse(response.body)
    search["flavor_text_entries"][0]["flavor_text"].gsub(/[\n\f]+/, " ")
  end
end