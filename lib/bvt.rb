# this class' task is to return a league object given a certain league's name.
class Bvt
  def self.load_federation(federation_name)
    case federation_name.downcase
    when 'vvb'
      Federation.new('VVB', VvbLoader)

    when 'avf'
      Federation.new('AVF', AvfLoader)

    when 'kovv'
      Federation.new('KOVV', KovvLoader)

    when 'klvv'
      Federation.new('KLVV', KlvvLoader)

    when 'vlm'
      Federation.new('VLM', VlmLoader)

    end
  end

  # return a list of all available leagues
  def self.get_federation_names
    'vvb,avf,kovv,klvv,vlm'.split(',')
  end
end

# import other parts of the library
require 'bvt/league.rb'
require 'bvt/game.rb'
require 'bvt/federation.rb'
require 'bvt/loader.rb'
require 'bvt/vvb_loader.rb'
require 'bvt/avf_loader.rb'
require 'bvt/kovv_loader.rb'
require 'bvt/klvv_loader.rb'
require 'bvt/vlm_loader.rb'
require 'bvt/league_stub.rb'
