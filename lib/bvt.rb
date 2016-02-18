require "net/http"
require "nokogiri"
require "date"



class Bvt
  def self.load_federation(federation_name)
    if federation_name.downcase == "vvb"
      puts "[INFO] loading #{federation_name}"

      leagues = VvbLoader.load
      f = Federation.new("VVB", leagues)
      return f
    end
  end
end


#import other parts of the library
require "bvt/league.rb"
require "bvt/game.rb"
require "bvt/federation.rb"
require "bvt/vvb_loader.rb"
