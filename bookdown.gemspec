# Make sure we get the gli that's local
require File.join([File.dirname(__FILE__),'lib','bookdown','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'bookdown'
  s.version = Bookdown::VERSION
  s.licenses = ['Apache-2.0']
  s.author = 'David Copeland'
  s.email = 'davidcopeland@naildrivin5.com'
  s.homepage = 'http://davetron5000.github.com/bookdown'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Create an online book driven by code examples that execute as you build the book'
  s.description = 'Createa  code-related book that has examples that actually run.  You can show users exactly what to do and how it will behave as you build the book'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   =  'bookdown'
  s.require_paths = ["lib"]

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.rubyforge_project = 'bookdown'
  s.add_dependency('redcarpet')
  s.add_dependency('sass')
  s.add_dependency('methadone')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
end
