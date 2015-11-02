# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/background/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-background"
  spec.version       = Capistrano::Background::VERSION
  spec.authors       = ["Chen Yi-Cyuan"]
  spec.email         = ["emn178@gmail.com"]

  spec.summary       = %q{Run background process for capistrano.}
  spec.description   = %q{Run background process for capistrano.}
  spec.homepage      = "https://github.com/emn178/capistrano-background.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.0.0"
  spec.add_dependency "terminate", ">= 0.1.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
