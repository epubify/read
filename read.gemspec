$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "read/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "read"
  s.version     = Read::VERSION
  s.authors     = ["Rune Myrland"]
  s.email       = ["rune@epubify.com"]
  s.homepage    = "http://epubify.com/"
  s.summary     = "Rails blog engine."
  s.description = "Plugin to add blog support to a rails app."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
