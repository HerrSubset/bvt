class Bvt
  def self.load_federation(federation_name)
    #make sure this function returns at least nil
    f = nil

    if federation_name.downcase == "vvb"
      f = Federation.new("VVB", VvbLoader)

    elsif federation_name.downcase == "avf"
      f = Federation.new("AVF", AvfLoader)

    elsif federation_name.downcase == "kovv"
      f = Federation.new("KOVV", KovvLoader)

    elsif federation_name.downcase == "klvv"
      f = Federation.new("KLVV", KlvvLoader)
    end

    return f
  end
end


#import other parts of the library
require "bvt/league.rb"
require "bvt/game.rb"
require "bvt/federation.rb"
require "bvt/loader.rb"
require "bvt/vvb_loader.rb"
require "bvt/avf_loader.rb"
require "bvt/kovv_loader.rb"
require "bvt/klvv_loader.rb"
require "bvt/league_stub.rb"
