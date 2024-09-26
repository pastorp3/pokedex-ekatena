require 'net/http'
require 'nokogiri'
require 'uri'
require 'cgi'
require_relative 'pokemon'

module PokedexScraper
  BASE_URL = 'https://www.pokemon.com/el/pokedex/'.freeze
  SCRAPE_DO_TOKEN = '93dd91d7fdad434c9369547a259accdf71b777ad1c7'

  class ScraperError < StandardError; end

  def self.scrape_pokemon(pokemon_name)
    formatted_name = pokemon_name.downcase.strip
    target_url = "#{BASE_URL}#{formatted_name}"

    encoded_url = CGI.escape(target_url)
    api_url = "https://api.scrape.do?url=#{encoded_url}&token=#{SCRAPE_DO_TOKEN}"

    url = URI(api_url)

    begin
      response = fetch_page(url)
      parse_pokemon_data(response)
    rescue ScraperError => e
      puts "Error: #{e.message}"
      nil
    end
  end

  private

  def self.fetch_page(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(uri)

    response = https.request(request)

    raise ScraperError, "Failed to retrieve page: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

    Nokogiri::HTML(response.body)
  end

  def self.parse_pokemon_data(doc)
    title = doc.at('div.pokedex-pokemon-pagination-title')&.text&.strip&.split(" ")
    raise ScraperError, "Failed to parse Pokémon data" unless title

    pokemon_name = title[0]
    pokemon_number = title[1]
    types = doc.css('div.dtm-type ul a').map(&:text).map(&:strip)
    skill = doc.at('a.moreInfo')&.text&.strip

    stats = doc.css('div.pokemon-stats-info.active li').each_with_object({}) do |li, hash|
      meter = li.at('ul.gauge li.meter')
      next unless meter

      value = meter['data-value']
      stat_name = li.at('span')&.text&.strip
      hash[stat_name] = value if stat_name && value
    end

    Pokemon.new(
      name: pokemon_name,
      number: pokemon_number,
      types: types,
      skill: skill,
      stats: stats
    )
  end
end
