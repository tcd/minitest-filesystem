lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "pathname"
require "minitest/filesystem/version"

Gem::Specification.new do |gem|
  gem.name          = "minitest-filesystem"
  gem.version       = Minitest::Filesystem::VERSION
  gem.authors       = ["Stefano Zanella"]
  gem.email         = ["zanella.stefano@gmail.com"]
  gem.description   = "Minitest exstension to check filesystem contents"
  gem.summary       = "Adds assertions and expectations to check the content of a filesystem tree with minitest"
  gem.homepage      = "https://github.com/stefanozanella/minitest-filesystem"
  gem.license       = "MIT"

  gem.required_ruby_version = ">= 2.3.0"

  gem.metadata = {
    "homepage_uri" => gem.homepage,
    "source_code_uri" => gem.homepage,
    "changelog_uri" => "#{gem.homepage}/blob/master/CHANGELOG.md",
    "yard.run" => "yri", # use "yard" to build full HTML docs.
  }

  gem.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|gem|spec|features)/}) }
  end
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 2.0"
  gem.add_development_dependency "coveralls", "~> 0.8.23"
  gem.add_development_dependency "minitest", "~> 5.0"
  gem.add_development_dependency "minitest-reporters", "~> 1.4"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "simplecov"

end
