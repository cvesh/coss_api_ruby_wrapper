# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coss_api_ruby_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = 'coss_api_ruby_wrapper'
  spec.version       = CossApiRubyWrapper::VERSION
  spec.authors       = ['Coss Community']
  spec.email         = ['admin@coss.community']

  spec.summary       = 'Trading API wrapper for cryptocurrency exchange https://coss.io'
  spec.homepage      = 'https://github.com/coss-community/coss_api_ruby_wrapper'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
  end
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
