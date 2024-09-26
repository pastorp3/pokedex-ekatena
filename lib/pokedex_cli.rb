module PokedexCLI
  def self.run_cli
    loop do
      display_menu
      choice = gets.chomp.strip

      case choice
      when '1'
        print "Enter the name of the Pokémon: "
        pokemon_name = gets.chomp.strip
        search_or_scrape_pokemon(pokemon_name)
      when '2'
        puts "Goodbye!"
        break
      else
        puts "Invalid option. Please choose 1 or 2."
      end
    end
  end

  private

  def self.display_menu
    puts "\nWelcome to the Pokémon CLI!"
    puts "1. Search for a Pokémon by name"
    puts "2. Exit"
    print "Enter your choice (1-2): "
  end

  def self.search_or_scrape_pokemon(pokemon_name)
    begin
      pokemon = PokedexDB.find_pokemon_by_name(pokemon_name)
      display_pokemon(pokemon)
    rescue PokedexDB::DatabaseError
      puts "Pokémon not found in the database. Scraping data..."
      pokemon = PokedexScraper.scrape_pokemon(pokemon_name)

      if pokemon
        PokedexDB.save_pokemon(pokemon)
        display_pokemon(PokedexDB.find_pokemon_by_name(pokemon_name))
      else
        puts "Error: Unable to scrape data for Pokémon '#{pokemon_name}'."
      end
    end
  end

  def self.display_pokemon(pokemon)
    puts "==============================="
    puts "Name: #{pokemon.name}"
    puts "Number: #{pokemon.number}"
    puts "Types: #{pokemon.types}"
    puts "Skill: #{pokemon.skill}"
    puts "Stats: #{pokemon.stats}"
    puts "==============================="
  end
end
