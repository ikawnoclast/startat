# -*- encoding: utf-8 -*-
require File.expand_path('../lib/startat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Keith Watson"]
  gem.email         = ["ikawnoclast@gmail.com"]
  gem.description   = %q{Start the execution of code at a future date and time.}
  gem.summary       = %q{StartAt is a Ruby class to execute a block at a future date and time.}
  gem.homepage      = "https://github.com/ikawnoclast/startat"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "startat"
  gem.require_paths = ["lib"]
  gem.version       = StartAt::VERSION
end
