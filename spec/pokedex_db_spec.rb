require 'sequel'
require_relative '../lib/pokedex_db'
require_relative '../lib/pokemon' # Include the Pokemon class

RSpec.describe PokedexDB do
  let(:pokemon) do
    Pokemon.new(
      name: 'Bulbasaur',
      number: '#001',
      types: ['Grass', 'Poison'],
      skill: 'Overgrow',
      stats: { 'HP' => '45', 'Attack' => '49' }
    )
  end

  before do
    PokedexDB::PokemonRecord.dataset.delete # Clear database for each test
  end

  describe '.save_pokemon' do
    it 'saves Pokémon data to the database' do
      expect {
        PokedexDB.save_pokemon(pokemon)
      }.to change { PokedexDB::PokemonRecord.count }.by(1)

      saved_pokemon = PokedexDB::PokemonRecord.last
      expect(saved_pokemon.name).to eq('Bulbasaur')
      expect(saved_pokemon.number).to eq('#001')
      expect(saved_pokemon.types).to eq('Grass, Poison')
    end
  end

  describe '.find_pokemon_by_name' do
    before do
      PokedexDB.save_pokemon(pokemon)
    end

    it 'retrieves the correct Pokémon from the database' do
      retrieved_pokemon = PokedexDB.find_pokemon_by_name('Bulbasaur')

      expect(retrieved_pokemon.name).to eq('Bulbasaur')
      expect(retrieved_pokemon.number).to eq('#001')
      expect(retrieved_pokemon.types).to eq('Grass, Poison')
    end

    it 'raises an error if the Pokémon is not found' do
      expect {
        PokedexDB.find_pokemon_by_name('Charmander')
      }.to raise_error(PokedexDB::DatabaseError, "No Pokémon found with the name 'Charmander'")
    end
  end
end
