class Bvt
  def self.load_federation(federation_name)
    #make sure this function returns at least nil
    f = nil
    puts "[INFO] loading #{federation_name}"

    if federation_name.downcase == "vvb"
      leagues = VvbLoader.load
      f = Federation.new("VVB", leagues)

    elsif federation_name.downcase == "avf"
      leagues = AvfLoader.load
      f = Federation.new("AVF", leagues)
    end

    return f
  end
end


#import other parts of the library
require "bvt/league.rb"
require "bvt/game.rb"
require "bvt/federation.rb"
require "bvt/vvb_loader.rb"
require "bvt/avf_loader.rb"
