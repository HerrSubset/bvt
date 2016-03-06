require "net/http"
require "nokogiri"
require "date"


class Bvt::VvbLoader
  #extracts the number of won sets by the home and away team for a score string
  def self.extractSets(results_node)
    home_sets = 0
    away_sets = 0

    #TODO

  	return home_sets, away_sets
  end


  #creates a Game object from the given nokogiri node
  def self.createGame(gameNode, resultsNode = nil)
  	#retrieve game information from this node
  	child = gameNode.child
  	code = child.text.downcase

  	child = child.next
    child = child.next
  	date = Date.parse(child.text)

    child = child.next
    time = child.text
    dt = DateTime.new(date.year, date.month, date.day, time[0..1].to_i, time[3..4].to_i)

  	child = child.next
  	home = child.text.downcase

  	child = child.next
  	away = child.text.downcase

  	child = child.next
  	location = child.text

    home_sets, away_sets = extractSets(resultsNode)

  	#create new game with the retrieved information
  	return Bvt::Game.new(code, home, away, dt, home_sets, away_sets)
  end



  #download the html page containing the games and extract the part
  #containing the relevant information. Return that part as a nokogiri node
  def self.getGameHtml()
  	uri = URI("http://www.volleyvvb.be/competitie-wedstrijden/")

  	#write html to file
  	post_options = {"Reeks" => "%", "Stamnummer" => "%", "Week" => "0"}
  	response = Net::HTTP.post_form(uri, post_options)


  	#let nokogiri parse the received html
  	doc = Nokogiri::HTML(response.body)


  	#find the html table containing all the games
  	table = doc.css("div#content div.entry table[cellpadding='1']")
  	return table[0]
  end



  def self.load()
    table = getGameHtml

    #create a hash to store all the leagues and their games
    res = Array.new

    #create the first league
    curChild = table.child
    curChild = curChild.next  #first child is empty
    curLeague = Bvt::League.new(curChild.text[12..-1])

    #create an array to store the current league's games
    res.push(curLeague)


    #loop through all table rows and extract useful information
    while !curChild.next.nil? do

      #go to the next item in the table
      curChild = 	curChild.next
      curClass = curChild.child["class"]


      if (curClass == "wedstrijd")
        #rows with this class contain game information. The next row contains
        #the game result (if available)
        g = createGame(curChild)

        #add the game to the league's array
        curLeague.add_game(g)


      elsif (curClass == "vvb_titel2")
        #rows with this class start a new league
        name = curChild.child.text[12..-1]
        curLeague = Bvt::League.new(name)
        res.push(curLeague)
      end
    end

    return res
  end
end
