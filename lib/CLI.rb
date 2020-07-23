class CLI
  
  Spacer = "----------------------------------------------------".colorize(:yellow)

  def call
    system("clear")
    @user_input = nil
    greeting

    until @user_input == 4
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
    
    @user_input = gets.chomp.to_i

    case @user_input
    when 1, 2
      search_pokemon
    when 3
      puts "stub menu 3"
    else 
      error_message unless @user_input == 4
    end
  end

  def search_pokemon
    system("clear")
    input = nil

    until input == 'back'
      search_input_prompt
      input = gets.chomp.downcase
      
      if valid_input_type?(input) && input != 'back'
        
        # stubs a valid search
        # calls API for a request
        # uses search history method / customer finder
        puts Spacer + "\nStub Pokemon Data\n"
        input = search_again?
      
      else 
        error_message
      end
    end
    system("clear")
  end

  def valid_input_type?(input)
    if @user_input == 1 || @user_input == 3
      if input =~ /\d/
        return false
      end
    else
      if input =~ /\D/
        return false
      end
    end
    return true
  end

  def search_input_prompt
    case @user_input
    when 1
      type = "Pokemon Name"
    when 2
      type = "Pokedex Number"
    when 3
      type = "Type"
    end

    print Spacer + "\nPlease Enter a valid #{type} \nor 'back' to go back to main menu:".colorize(:light_black)
  end

  def search_again?
    input = ""

    until input == "n" || input == "no"
      print Spacer + "\nWould you like to do another search? Y/N:".colorize(:light_black)
      input = gets.chomp.downcase

      if input == "y" || input == "yes"
        system("clear") ; return
      else 
        error_message unless input == "n" || input == "no"
      end
    end

    system("clear") ; "back"
  end
  
  def error_message
    system("clear") ; puts Spacer + "\nSorry! I didn't understand that".colorize(:red)
  end

end