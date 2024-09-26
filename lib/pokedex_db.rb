require 'sequel'
require 'json'
require_relative 'pokemon'

module PokedexDB
  class DatabaseError < StandardError; end

  DB = Sequel.connect('sqlite://pokedex.db')

  DB.create_table? :pokemons do
    primary_key :id
    String :name, null: false
    String :number, null: false
    String :types, null: false
    String :skill
    String :stats, text: true
  end

  class PokemonRecord < Sequel::Model(:pokemons); end

  def self.save_pokemon(pokemon)
    begin
      PokemonRecord.create(
        name: pokemon.name,
        number: pokemon.number,
        types: pokemon.types,
        skill: pokemon.skill,
        stats: pokemon.stats.to_json
      )
      puts "Successfully saved #{pokemon.name} to the database."
    rescue Sequel::Error => e
      raise DatabaseError, "Failed to save Pokémon: #{e.message}"
    end
  end

  def self.find_pokemon_by_name(name)
    record = PokemonRecord.where(Sequel.ilike(:name, name.strip)).first
    raise DatabaseError, "No Pokémon found with the name '#{name}'" unless record

    Pokemon.new(
      name: record.name,
      number: record.number,
      types: record.types.split(', '),
      skill: record.skill,
      stats: JSON.parse(record.stats)
    )
  end
end
