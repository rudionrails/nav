# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nav/version"

Gem::Specification.new do |s|
  s.name        = "nav"
  s.version     = Nav::VERSION
  s.authors     = ["Rudolf Schmidt"]

  s.homepage    = ""
  s.summary     = %q{Simple nagivation builder}
  s.description = %q{Simple nagivation builder}

  s.rubyforge_project = "nav"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'actionpack', '~> 3'
  s.add_development_dependency 'rr'
end
