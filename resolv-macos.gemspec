require_relative 'lib/resolv/macos/version'

Gem::Specification.new do |spec|
  spec.name          = "resolv-macos"
  spec.version       = Resolv::Macos::VERSION
  spec.authors       = ["Max Fierke"]
  spec.email         = ["max@maxfierke.com"]

  spec.summary       = %q{macOS multiple resolver support for Resolv}
  spec.description   = %q{Adds support for macOS's multiple resolver configs to Resolv's default set of resolvers.}
  spec.homepage      = "https://github.com/maxfierke/resolv-macos"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "resolv"
end
