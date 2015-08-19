Gem::Specification.new do |s|

  s.name        = "ruby-swift"
  s.version     = "0.1.3"
  s.date        = "2015-08-16"

  s.summary     = "A ruby wrapper of the Swift Digital Suite API."
  s.description = "A ruby wrapper of the Swift Digital Suite Mail House API (https://suite.swiftdigital.com.au)."

  s.authors     = ["Andrew Buntine"]
  s.email       = "info@bunts.io"
  s.homepage    = "http://github.com/buntine/RubySwift"

  s.files       = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.license     = "MIT"

  s.add_runtime_dependency "savon"

  s.platform = Gem::Platform::RUBY

  s.require_paths = %w[lib]

end
