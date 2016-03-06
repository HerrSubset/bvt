class Bvt
  def self.load_federation(federation_name)
    #make sure this function returns at least nil
    f = nil

    if federation_name.downcase == "vvb"
      f = Federation.new("VVB", VvbLoader)

    elsif federation_name.downcase == "avf"
      f = Federation.new("AVF", AvfLoader, false)
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
