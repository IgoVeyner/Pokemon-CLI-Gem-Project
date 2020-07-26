class CLI
  
  Spacer = "--------------------------------------------------------".colorize(:yellow)

  attr_reader :user_main_menu_input, :user_search_menu_input, :api, :response

  def call
    system("clear")
    @user_main_menu_input = nil
    @api = APIService.new
    greeting

    until @user_main_menu_input == 4
      main_menu
    end
    puts Spacer + "\nGoodbye!\n".colorize(:light_black) + Spacer
  end

  # Prints greeting
  def greeting
    puts Spacer + "\nWelcome to the Pokemon CLI gem!".colorize(:light_black)
  end

  # Prints main menu, asks for user input, exits when user input is '4'
  def main_menu
    puts Spacer + "\nWhat Would you like to do today?\n" .colorize(:light_black)
    puts "1. Search Pokemon by Name"
    puts "2. Search Pokemon by Pokedex Number"
    puts "3. Search Pokemon by Type"
    puts "4. Exit\n"
    print Spacer + "\nPlease Enter a Number 1 - 4:".colorize(:light_black)  
    @user_main_menu_input = gets.chomp.to_i

    case @user_main_menu_input
    when 1, 2, 3 
      search_menu
    else 
      menu_error_message unless @user_main_menu_input == 4
    end
  end

  # Prints the search menu, asks for input, returns to main menu when input is 'back'
  def search_menu
    system("clear")
    @user_search_menu_input = nil

    until @user_search_menu_input == 'back'
      search_input_prompt
      @user_search_menu_input = gets.chomp.downcase
      unless @user_search_menu_input == 'back'
        case @user_main_menu_input
        when 1
          search_pokemon_by_name
        when 2
          search_pokemon_by_number
        when 3
          search_by_type
        end
      end
    end
    system("clear")
  end

    # These three methods 'smell'. They are very similar and could be combined into one...
    # I would need to use helper methods with case statments looking at the @user_main_menu_input to provide functionality
    # Is that the right thing to do?
    # Will it make adding features harder or easier in the future?
    # Should I be relying on a conditional statement that much?
  
  # Asks APIService to find or create a search request, 
  # prints response and asks if you want to do another search
  # prints an error when invalid response or input error
  def search_pokemon_by_name 
    @api.find_or_create_search_request(@user_search_menu_input, "pokemon") 
    if !(@user_search_menu_input.match(/ \d/)) && @api.valid_response?
      print_search_results
      search_again_menu
    else
      search_error_message
    end
  end

  # Asks APIService to find or create a search request, 
  # prints response and asks if you want to do another search
  # prints an error when invalid response or input error
  def search_pokemon_by_number
    @api.find_or_create_search_request(@user_search_menu_input, "pokemon")
    if @user_search_menu_input.to_i > 0 && @api.valid_response?
      print_search_results
      search_again_menu
    else
      search_error_message
    end
  end

  # Asks APIService to find or create a search request, 
  # prints response and asks if you want to do another search
  # prints an error when invalid response or input error
  def search_by_type
    @api.find_or_create_search_request(@user_search_menu_input, "type")
    if !(@user_search_menu_input.match?(/\d/)) && @api.valid_response?
      print_search_results
      search_again_menu
    else
      search_error_message
    end
  end

  # Prints appropriate search response
  def print_search_results
    system("clear") 
    puts Spacer
    if @user_main_menu_input == 1 || @user_main_menu_input == 2
      @api.read_pokemon_response 
    end
    @api.read_type_response if @user_main_menu_input == 3
  end

  # Prints propmt for search menu, checks instance variable for correct search type in prompt
  def search_input_prompt
    search_type = case @user_main_menu_input
      when 1 
        "Pokemon Name"
      when 2
        "Pokedex Number"
      when 3
        "Type"
      end
    print Spacer + "\nPlease Enter a #{search_type} \nor 'back' to go back to main menu:".colorize(:light_black)
  end

  # Asks if the user wants to do the search again
  # If yes, will break out of search_again_menu loop and return into search_menu_loop
  # If no, will update instance variable to break out of both search_again_loop and search_menu loop back into main menu loop
  def search_again_menu
    search_again_input = ""

    until search_again_input == "n" || search_again_input == "no"
      print Spacer + "\nWould you like to do another search? Y/N:".colorize(:light_black)
      search_again_input = gets.chomp.downcase
      
      case search_again_input
      when "y", "yes"
        system("clear")
        return
      else
        menu_error_message
      end
    end
    system("clear")
    @user_search_menu_input = "back"
  end

  # error message in main menu & search_again_menu
  def menu_error_message
    system("clear")
    puts Spacer + "\nSorry! I didn't understand that.".colorize(:red)
  end

  # error message if bad input type or bad response
  def search_error_message
    system("clear")
    puts Spacer + "\nSorry! ".colorize(:red) + @user_search_menu_input + " is not a valid input.".colorize(:red)
  end
end