class APIService
  
  BASE_URI = "https://pokeapi.co/api/v2/"
  
  def initialize
    
  end

  def make_request(name_or_type, user_input)
    uri = URI(BASE_URI + "#{name_or_type}/#{user_input}/")
    response = Net::HTTP.get_response(uri)
  end
  
  # JSON.parse(response.body)
end