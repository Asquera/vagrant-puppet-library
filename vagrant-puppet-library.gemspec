# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-puppet-library/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-puppet-library"
  spec.version       = Vagrant::Puppet::Library::VERSION
  spec.authors       = ["Felix Gilcher"]
  spec.email         = ["felix.gilcher@asquera.de"]
  spec.license       = 'MIT'
  spec.homepage      = "https://github.com/Asquera/vagrant-puppet-library"
  spec.summary       = %q{Run puppet-library in your Vagrantfiles}
  spec.description   = %q{A plugin to vagrant that allows running a private puppetforge (puppet-library) inside a vagrant env.}

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "puppet-library", "~> 0.13"
  spec.add_dependency "i18n"
  spec.add_dependency "log4r"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-core", "~> 2.12.2"
  spec.add_development_dependency "rspec-expectations", "~> 2.12.1"
  spec.add_development_dependency "rspec-mocks", "~> 2.12.1"

end
