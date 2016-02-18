Gem::Specification.new do |s|
  s.name        = 'bvt'
  s.version     = '0.0.0'
  s.date        = '2016-02-18'
  s.summary     = "Belgian Volley Tools"
  s.description = "Tools to interact with the various belgian volleyball federations' data"
  s.authors     = ["HerrSubset"]
  s.files       = ["lib/bvt.rb", "lib/bvt/league.rb", "lib/bvt/game.rb", "lib/bvt/federation.rb", "lib/bvt/vvb_loader.rb"]
  s.executables   << "bvt"
  s.license     = 'MIT'
end
