namespace :pokemon do
  desc "Scrapes pokemon from the internet"
  task create: :environment do

    Pokemon.destroy_all

    require "open-uri"

    base_url = "http://pokemon.wikia.com/"
    index_page = "List_of_Pokémon#Generation I"

    require 'webrick/httputils'

    query=base_url + index_page

    query.force_encoding("binary")

    query = WEBrick::HTTPUtils.escape(query)


    pokedex = Nokogiri::HTML(open(query))
    # puts pokedex

    tables = pokedex.css(".wikitable")

    generation_1 = tables[0]

    gen_list = generation_1.css("tr")

    gen_list.each_with_index do |p, index|
      unless p.css("a")[1].nil?
        poke_url = p.css("a")[1].attributes["href"].value

        single_pokemon = Nokogiri::HTML(open(base_url + poke_url))

        name = single_pokemon.css("h1").text
        image_list = single_pokemon.css(".floatnone .image-thumbnail img")

        image_list.each do |p|
          if p.attributes["width"].value == "200" && p.attributes["width"] != nil
            @image = p["src"]
            break if @image =~ /http*/
          end#break if
        end#image_list

        image_list.each do |p|
          if p.attributes["height"].value == "32" && p.attributes["width"] != nil
            @icon = p["data-src"] || p.attributes["src"].value
            break;
          end
        end

        puts index
        puts name
        puts @icon
        puts @image
        puts ""

        @pokemon = Pokemon.create(id: index, name: name, icon: @icon, image: @image)
      end #unless
    end #gen_list.each_with_index
  end #task
end #namespace
