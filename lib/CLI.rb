class CLI
  
  Spacer = "--------------------------------------------------------".colorize(:yellow)

  attr_reader :main_menu_input, :search_menu_input, :api, :api_search_type

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

    unless @main_menu_input == 4
      case @main_menu_input
      when 1, 2
        @api_search_type ="pokemon"
        search_menu
      when 3
        @api_search_type = "type"
        search_menu
      else 
        menu_error 
      end
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
          @api.find_or_create_search_request(@search_menu_input, @api_search_type)
          if @api.valid_response?
            print_search_results
            search_again_menu
          else 
            search_error
          end
        else
          input_type_error
        end
      end
    end
    system("clear")
  end
  
  # validates that user isnt typing numbers for a name search and letters for a number search
  def valid_input_type?
    case @main_menu_input
    when 1, 3
      !@search_menu_input.match?(/\d/)
    when 2
      !@search_menu_input.match?(/\D/)
    end
  end

  # Prints appropriate search response
  def print_search_results
    system("clear") 
    puts Spacer
    if @main_menu_input == 1 || @main_menu_input == 2
      @api.read_pokemon_response 
    end
    @api.read_type_response if @main_menu_input == 3
  end

  # Prints propmt for search menu, checks instance variable for correct search type in prompt
  def search_prompt
    search_type = case @main_menu_input
      when 1 
        "Pokemon Name"
      when 2
        "Pokedex Number"
      when 3
        "Type"
      end
    puts Spacer 
    print "Please Enter a #{search_type} \nor 'back' to go back to main menu:".colorize(:light_black)
  end

  # Asks if the user wants to do the search again
  # If yes, will break out of search_again_menu loop and return into search_menu_loop
  # If no, will update instance variable to break out of both search_again_loop and search_menu loop back into main_menu loop
  def search_again_menu
    search_again_input = ""

    until search_again_input == "n" || search_again_input == "no"
      puts Spacer
      print "Would you like to do another search? Y/N:".colorize(:light_black)
      search_again_input = gets.chomp.downcase
      
      case search_again_input
      when "y", "yes"
        system("clear")
        return
      else
        menu_error
      end
    end
    system("clear")
    @search_menu_input = "back"
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
  def input_type_error
    system("clear")
    puts Spacer
    type = case @main_menu_input
      when 1, 3
        "numbers"
      when 2
        "letters"
      end
    puts "Sorry! No #{type} please!".colorize(:red)
  end
end