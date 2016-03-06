# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'bvt'
  s.version     = '0.0.0'
  s.date        = '2016-02-18'
  s.summary     = "Belgian Volley Tools"
  s.description = "Tools to interact with the various belgian volleyball federations' data"
  s.authors     = ["HerrSubset"]
  s.files       = Dir.glob("{bin,lib}/**/*")
  s.license     = 'MIT'
end
