# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'read_only_filter/version'

Gem::Specification.new do |gem|
  gem.name          = "read_only_filter"
  gem.version       = ReadOnlyFilter::Rails::VERSION
  gem.authors       = ["Geo"]
  gem.email         = ["geo.marshall@gmail.com"]
  gem.description   = %q{Read only support for Rails ActiveController, allows for protection of controller actions from create/update/destroy.}
  gem.summary       = %q{Enable read only protection for rails controller actions.}
  gem.homepage      = ""

  gem.files         = Dir["{lib}/**/*"] + ["README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  # There are no dependencies initialy created for use with rails 3.2.12.
end
