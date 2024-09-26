
# Pokedex Ekatena

Pokedex Ekatena is a Ruby-based application that scrapes data from the official Pokémon website and stores it in a database. It provides a CLI (Command Line Interface) for searching Pokémon data, including their types, abilities, and stats.

## Features

- Scrapes Pokémon data from the official Pokémon website (https://www.pokemon.com/el/pokedex/).
- Stores Pokémon data in a database (SQLite by default).
- Provides a simple CLI for searching and retrieving Pokémon data by name.
- Supports caching to prevent redundant web scrapes.
- Data includes: Pokémon name, number, types, abilities, and base stats (HP, Attack, etc.).

## Prerequisites

### 1. Ruby

Ensure you have Ruby installed on your machine. You can check if Ruby is installed by running:


ruby -v


If Ruby is not installed, follow the instructions on the official [Ruby website](https://www.ruby-lang.org/en/documentation/installation/) to install it.

### 2. Scrape.do API Registration

This project uses the [Scrape.do](https://scrape.do) service to bypass anti-scraping mechanisms on the official Pokémon website.

You will need to:
1. **Register for an API token** on the [Scrape.do website](https://scrape.do).
2. After registering, you'll get an API token. Update the `SCRAPE_DO_TOKEN` constant in `lib/pokedex_scraper.rb` with your token:

```ruby
SCRAPE_DO_TOKEN = 'your_scrape_do_api_token_here'
```

### 3. Gems (Dependencies)

The following gems are required for this project:
- `net/http`
- `nokogiri`
- `uri`
- `cgi`
- `sequel`
- `json`
- `rspec` (for testing)

You can install each gem manually:

```bash
gem install net-http
gem install nokogiri
gem install sequel
gem install json
gem install rspec
```

## Setup

1. **Clone the repository**:
   
   ```bash
   git clone git@github.com:pastorp3/pokedex-ekatena.git
   cd pokedex-ekatena
   ```

2. **Install the required gems**:

   As this project does not use Bundler or a `Gemfile`, you will need to manually install the necessary gems. You can do so by running:

   ```bash
   gem install net-http nokogiri sequel json rspec
   ```

3. **Set up the database**:

   The database is set up automatically when running the app, but if you want to ensure everything is in place, you can run:

   ```bash
   sqlite3 pokedex.db
   ```

4. **Update the Scrape.do API token**:

   After registering with [Scrape.do](https://scrape.do), add your token to the scraper configuration in `lib/pokedex_scraper.rb`:

   ```ruby
   SCRAPE_DO_TOKEN = 'your_scrape_do_api_token_here'
   ```

## Running the Application

### Running the CLI

You can interact with the Pokedex via the command-line interface:

```bash
ruby main.rb
```

The CLI allows you to search for a Pokémon by name and retrieves its data from the local database or scrapes it from the official website if it's not found locally.

### Example:

```bash
$ ruby main.rb

Welcome to the Pokémon CLI!
1. Search for a Pokémon by name
2. Exit
Enter your choice (1-2): 1
Enter the name of the Pokémon: bulbasaur

===============================
Name: Bulbasaur
Number: #001
Types: Grass, Poison
Skill: Overgrow
Stats: {"HP" => "45", "Attack" => "49"}
===============================
```

## Running Tests

The project includes unit tests for the scraper and database modules. To run the tests, ensure that `rspec` is installed:

```bash
gem install rspec
```

Then, run the tests with:

```bash
rspec
```

## Project Structure

- **lib/**
  - `pokedex_scraper.rb`: Handles scraping Pokémon data from the website.
  - `pokedex_db.rb`: Handles database interactions for saving and retrieving Pokémon data.
  - `pokedex_cli.rb`: Provides the command-line interface for interacting with the Pokémon database.
  - `pokemon.rb`: Defines the `Pokemon` class that encapsulates Pokémon data.
  
- **spec/**: Contains RSpec unit tests for the scraper, database, and CLI.
