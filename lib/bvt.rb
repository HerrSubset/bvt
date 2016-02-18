require "net/http"
require "nokogiri"
require "date"



class Bvt
  def self.load_federation(federation_name)
    if federation_name.downcase == "vvb"
      puts "[INFO] loading #{federation_name}"

      leagues = load_vvb_leagues
      f = Federation.new("VVB", leagues)
      return f
    end
  end


  #extracts the number of won sets by the home and away team for a score string
  def self.extractSets(scoreString)
  	home_sets = scoreString[9].to_i
  	away_sets = scoreString[13].to_i

  	return home_sets, away_sets
  end


  #creates a Game object from the given nokogiri node
  def self.createGame(gameNode)
  	#retrieve game information from this node
  	child = gameNode.child
  	code = child.text.downcase

  	child = child.next
  	date = Date.parse(child.text)

  	child = child.next
  	home = child.text.downcase

  	child = child.next
  	away = child.text.downcase

  	child = child.next
  	home_sets, away_sets = extractSets(child.text)

  	#create new game with the retrieved information
  	return Game.new(home, away, home_sets, away_sets, date)
  end



  #download the html page containing the games and extract the part
  #containing the relevant information. Return that part as a nokogiri node
  def self.getGameHtml()
  	uri = URI("http://www.volleyvvb.be/competitie-uitslagen/")

  	#write html to file
  	post_options = {"Reeks" => "%", "Stamnummer" => "%", "Week" => "0"}
  	response = Net::HTTP.post_form(uri, post_options)
  	puts "[INFO] download completed"


  	#let nokogiri parse the received html
  	doc = Nokogiri::HTML(response.body)


  	#find the html table containing all the games
  	table = doc.css("div#content div.entry table[align=center]")
  	return table[0]
  end



  def self.load_vvb_leagues()
    table = getGameHtml

    #create a hash to store all the leagues and their games
    res = Array.new

    #create the first league
    curChild = table.child
    curLeague = League.new(curChild.text[12..-1])

    #create an array to store the current league's games
    res.push(curLeague)


    #loop through all table rows and extract useful information
    while !curChild.next.nil? do

      #go to the next item in the table
      curChild = 	curChild.next
      curClass = curChild.child["class"]


      if (curClass == "vvb_tekst_middelkl")
        #rows with this class contain game information.
        g = createGame(curChild)

        #add the game to the league's array
        curLeague.add_game(g)


      elsif (curClass == "vvb_titel2")
        #rows with this class start a new league
        name = curChild.child.text[12..-1]
        curLeague = League.new(name)
        res.push(curLeague)
        puts "[INFO] Adding games for #{name}"
      end
    end

    return res
  end
end


#import other parts of the library
require "bvt/league.rb"
require "bvt/game.rb"
require "bvt/federation.rb"
