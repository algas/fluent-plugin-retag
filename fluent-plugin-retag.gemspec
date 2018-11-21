# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-retag"
  gem.version       = "0.1.1"
  gem.authors       = ["Masahiro Yamauchi"]
  gem.email         = ["sgt.yamauchi@gmail.com"]
  gem.description   = %q{Output filter plugin to retag}
  gem.summary       = %q{Output filter plugin to retag}
  gem.homepage      = "https://github.com/algas/fluent-plugin-retag"

  gem.rubyforge_project = "fluent-plugin-retag"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "rake", "~> 12.0"
  gem.add_development_dependency "test-unit", "~> 3.2"
  gem.add_runtime_dependency "fluentd", [">= 0.14.8", "< 2"]
end
