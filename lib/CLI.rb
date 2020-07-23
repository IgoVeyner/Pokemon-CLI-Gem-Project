class CLI
  
  Spacer = "----------------------------------------------------".colorize(:yellow)

  def call
    system("clear")
    @user_input = nil
    greeting

    until @user_input == "4"
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
    puts "2. Search Pokemon by Pokedex #"
    puts "3. Search Pokemon by Type"
    puts "4. Exit\n"
    print Spacer + "\nPlease Enter a Number 1 - 4:".colorize(:light_black)
    
    @user_input = gets.chomp

    case @user_input
    when "1"
      search_by_name
    when "2"
      puts "stub menu 2"
    when "3"
      puts "stub menu 3"
    else 
      error_message unless @user_input == "4"
    end
  end

  def search_by_name
    system("clear")
    input = nil

    until input == 'back'
      print Spacer + "\nPlease Enter a Pokemon name \nor 'back' to go back to main menu:".colorize(:light_black)
      input = gets.chomp

      if input == "back"
        system("clear")
        return
      else
        # calls API for a request
        # uses search history method / customer finder
        
        validate = true     # stubs a valid search
        if validate == true
          puts Spacer + "\nStub Pokemon Data\n"
          input = search_another_name?
        end
      end
    end
  end

  def search_another_name?
    input = ""

    until input == "n"
      print Spacer + "\nWould you like to search for another Pokemon? Y/N:".colorize(:light_black)
      input = gets.chomp.downcase

      if input == "y"
        system("clear") ; return
      else 
        error_message unless input == "n"
      end
    end

    system("clear") ; "back"
  end
  
  def error_message
    system("clear") ; puts Spacer + "\nSorry! I didn't understand that".colorize(:red)
  end

end