class CLI
  
  Spacer = "-------------------------------------------------------------".colorize(:yellow)

  def call
    system("clear")
    @main_menu_input = nil
    @api = APIService.new
    greeting

    until @main_menu_input == 4
      main_menu
    end
    puts Spacer 
    puts "Goodbye!".colorize(:light_black)
    puts Spacer
  end


  # Prints greeting
  def greeting
    puts Spacer 
    puts "Welcome to the Pokemon CLI gem!".colorize(:light_black)
  end


  # Prints main menu, asks for user input, breaks out of loop when user input is '4'
  def main_menu
    puts Spacer 
    puts "What Would you like to do today?".colorize(:light_black)
    puts ""
    puts "1. Search Pokemon by Name"
    puts "2. Search Pokemon by Pokedex Number"
    puts "3. Search Pokemon by Type"
    puts "4. Exit"
    puts ""
    puts Spacer
    print "Please Enter a Number 1 - 4:".colorize(:light_black)  
    @main_menu_input = gets.chomp.to_i

    case @main_menu_input
    when 1
      @search_type = "Pokemon Name" 
      search_menu
    when 2
      @search_type = "Pokedex Number"
      search_menu
    when 3 
      @search_type = "Type"
      search_menu
    else 
      menu_error unless @main_menu_input == 4
    end
  end


  # Prints the search menu, asks for input, returns to main_menu loop when input is 'back'
  def search_menu
    system("clear")
    @search_menu_input = nil

    until @search_menu_input == 'back'
      search_prompt
      @search_menu_input = gets.chomp.downcase

      unless @search_menu_input == 'back'
        if valid_input_type?
          find_or_create_search_request
          if @api.valid_response?
            print_search_results
            next_menu
          else 
            search_error
          end
        else 
          type_error
        end
      end
    end
    system("clear")
  end


  # Finds previous search from search history or creates the appropriate search request
  def find_or_create_search_request
    @api.find_or_create_search_request(@search_menu_input, "pokemon") if @search_type.match?(/^Pokemon Name$|^Pokedex Number$/)
    @api.find_or_create_search_request(@search_menu_input, "type") if @search_type.match?(/^Type$/)
  end


  # Updates the search type and the input to be searched and sends it to be found or created
  def find_or_create_search_request_from_learn_more(pokemon_array)
    index = @learn_more_input.to_i - 1
    @search_menu_input = pokemon_array[index].name
    @search_type = "Pokemon Name"
    find_or_create_search_request
  end
  

  # Handles which menu the user will enter
  def next_menu
    search_again_menu if @search_type.match?(/^Pokemon Name$|^Pokedex Number$/)
    learn_more_menu if @search_type.match?(/^Type$/)
  end


  # validates that user isnt typing numbers for a name search and letters for a number search
  def valid_input_type?
    case @search_type
    when "Pokemon Name", "Type"
      !@search_menu_input.match?(/\d/) 
    when "Pokedex Number"
      !@search_menu_input.match?(/\D/)
    end
  end


  # Prints appropriate search response
  def print_search_results
    system("clear") 
    puts Spacer

    if @search_type.match?(/^Pokemon Name$|^Pokedex Number$/)
      pokemon_ins = @api.read_pokemon_response
      pretty_text_pokemon(pokemon_ins) 
    elsif @search_type.match?(/^Type$/)
      type_ins = @api.read_type_response 
      print_all_type(type_ins)
    end
  end


  # Prints propmt for search menu, checks instance variable for correct search type in prompt
  def search_prompt
    puts Spacer 
    puts "Please Enter a #{@search_type}".colorize(:light_black)
    print "or 'back' to go back to main menu:".colorize(:light_black)
  end


  # Asks if the user wants to do the search again
  # If yes, will break out of search_again_menu loop and return into search_menu_loop
  # If no, will update instance variable to break out of both search_again_loop and search_menu loop back into main_menu loop
  def search_again_menu
    search_again_input = ""

    until search_again_input.match?(/^yes$|^y$|^no$|^n$/)
      puts Spacer
      print "Would you like to do another search? Y/N:".colorize(:light_black)

      search_again_input = gets.chomp.downcase   
      search_again_input.match?(/^n$|^no$/) ? @search_menu_input = "back" : menu_error unless search_again_input.match?(/^yes$|^y$/)
    end
    system("clear")
  end


  # Allows the user to get more info on a pokemon from previous list, go back to type search or go back to main menu
  def learn_more_menu
    @learn_more_input = ""

    last_search = @api.search_history.select{|s| s[:search_type] == "type"}.last[:input]
    pokemon_array = Type.all.find{|t| t.name == last_search}.pokemon_array
    
    until @learn_more_input.match?(/^again$|^back$/) || @learn_more_input.to_i.between?(1, pokemon_array.size)
      puts Spacer
      puts "Enter the number of a Pokemon".colorize(:light_black)
      puts "you would like to get more info on,".colorize(:light_black)
      puts "'again' to search again,".colorize(:light_black)
      print "or 'back' to go back to main menu.".colorize(:light_black)
      
      @learn_more_input = gets.chomp.downcase
    
      case 
      when @learn_more_input == "back" 
        system("clear")
        @search_menu_input = "back"
      when @learn_more_input == "again"
        system("clear")
      when @learn_more_input.to_i.between?(1, pokemon_array.size)
        if valid_input_type?
          find_or_create_search_request_from_learn_more(pokemon_array)
          if @api.valid_response?
            print_search_results
            learn_more_end_menu
          else
            search_error
          end
        else
          type_error
        end
      else
        menu_error
      end
    end
  end
  

  # Asks the user to choose between going back to the main menu and searching for another type
  def learn_more_end_menu
    until @learn_more_input.match?(/^again$|^back$/)
      puts Spacer
      puts "Enter 'again' to search for another type".colorize(:light_black)
      print "or 'back' to go back to main menu:".colorize(:light_black)

      @learn_more_input = gets.chomp.downcase

      system("clear")
      case @learn_more_input
      when "back"
        @search_menu_input = "back"
      when "again"
        @search_type = "Type"
      else 
        menu_error unless @learn_more_input.match?(/^again$|^back$/)
      end
    end
  end


  # error message in main menu & search_again_menu
  def menu_error
    system("clear")
    puts Spacer
    puts "Sorry! I didn't understand that.".colorize(:red)
  end


  # if user input creates bad response
  def search_error
    system("clear")
    puts Spacer
    puts "Sorry! ".colorize(:red) + @search_menu_input + " is not a valid input.".colorize(:red)
  end
  

  # if user enters the wrong type
  def type_error
    system("clear")
    puts Spacer

    type = case @search_type
    when "Pokemon Name", "Type"
      "numbers"
    when "Pokedex Number"
      "letters"
    end
    
    puts "Sorry! No #{type} please!".colorize(:red)
  end

  # Prints the Pokemon's data, nice and pretty
  def pretty_text_pokemon(pokemon_ins)
    puts "#{pokemon_ins.name.capitalize}\n"
    print "Type: #{pokemon_ins.types_array[0].name.capitalize}" 
    print "/#{pokemon_ins.types_array[1].name.capitalize}" if pokemon_ins.types_array[1] 
    puts ""
    puts "\n#{pokemon_ins.pokedex_entry}"
    puts "\nHeight: #{(pokemon_ins.height *  3.937).round(2)} in / #{(pokemon_ins.height * 0.1).round(2)} m"
    puts "Weight: #{(pokemon_ins.weight / 4.536).round(1)} lb / #{(pokemon_ins.weight * 0.1).round(2)} kg"
  end

  # Prints all the pokemon that belong to the current type instance
  def print_all_type(type_ins)
    type_ins.pokemon_array.each.with_index(1) {|p,i| puts "#{i}. #{p.name}"}
  end
end