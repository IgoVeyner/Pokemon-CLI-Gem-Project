class CLI
  
  Spacer = "----------------------------------------------------".colorize(:yellow)

  def call
    system("clear")
    @user_input = nil
    greeting

    until @user_input == "4"
      main_menu
    end

    puts "Goodbye!".colorize(:light_black)
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
    # binding.pry
    
    @user_input = gets.chomp
  end

end