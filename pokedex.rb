require_relative 'lib/pokedex_scraper'
require_relative 'lib/pokedex_db'
require_relative 'lib/pokedex_cli'

def main
  PokedexCLI.run_cli
end

main