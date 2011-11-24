# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trunction/version"

Gem::Specification.new do |s|
  s.name        = "trunction"
  s.version     = Trunction::VERSION
  s.authors     = ["Mike Williams"]
  s.email       = ["mdub@dogbiscuit.org"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "trunction"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "nokogiri"

end
