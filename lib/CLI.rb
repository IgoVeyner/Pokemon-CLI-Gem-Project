class CLI
  
  Spacer = "----------------------------------------------------".colorize(:yellow)

  attr_reader :user_main_menu_input, :user_search_input, :api, :response

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


  def greeting
    puts Spacer + "\n" + "Welcome to the Pokemon CLI gem!".colorize(:light_black)
  end


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
      @search_type = @user_main_menu_input == 1 || @user_main_menu_input == 2 ? "pokemon" : "type"
      search
    else 
      main_error_message unless @user_main_menu_input == 4
    end
  end


  def search
    system("clear")
    @user_search_input = nil

    until @user_search_input == 'back'
      search_input_prompt
      @user_search_input = gets.chomp.downcase  

      if valid_input? && @user_search_input != 'back'
        system("clear")
        
        # uses search history method / customer finder to not request the api when not needed
        puts Spacer 
        puts case @user_main_menu_input 
          when 1, 2
            pokemon = @api.read_pokemon_response(@response)
            pokemon.pretty_text
          when 3
            "Stub Pokemon Data 3\n"
          end

          @user_search_input = search_again?
      else 
        system("clear")
        puts Spacer + "\nSorry! ".colorize(:red) + @user_search_input + " is not a valid input.".colorize(:red)
      end
    end
    system("clear")
  end


  def valid_input?
    valid_input_type? && good_response?
  end
  

  def valid_input_type?
    case @user_main_menu_input
    when 1, 3
      if @user_search_input =~ /\d/ #can't use numbers when searching for a name
        false
      end
    when 2
      if @user_search_input =~ /\D/ #can't use letters when searching for a number
        false
      end
    end
    true
  end
  

  def good_response?
    @response = @api.make_request(@search_type, @user_search_input)
    @response.is_a?(Net::HTTPSuccess)
  end


  def search_input_prompt
    search = case @user_main_menu_input
      when 1
        "Pokemon Name"
      when 2
        "Pokedex Number"
      when 3
        "Type"
      end
    print Spacer + "\nPlease Enter a valid #{search} \nor 'back' to go back to main menu:".colorize(:light_black)
  end


  def search_again?
    @user_search_input = ""
    until @user_search_input == "n" || @user_search_input == "no"
      print Spacer + "\nWould you like to do another search? Y/N:".colorize(:light_black)
      @user_search_input = gets.chomp.downcase

      if @user_search_input == "y" || @user_search_input == "yes"
        system("clear") ; return
      else 
        main_error_message unless @user_search_input == "n" || @user_search_input == "no"
      end
    end
    system("clear") ; "back"
  end
  
  
  def main_error_message
    system("clear") ; puts Spacer + "\nSorry! I didn't understand that.".colorize(:red)
  end

end