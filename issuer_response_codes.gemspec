# frozen_string_literal: true

require_relative 'lib/issuer_response_codes/version'

Gem::Specification.new do |spec|
  spec.name          = 'issuer_response_codes'
  spec.version       = IssuerResponseCodes::VERSION
  spec.authors       = ['Espago', 'Mateusz Drewniak']
  spec.email         = ['m.drewniak@espago.com']

  spec.summary       = 'Issuer Response Code descriptions for cardholders and merchants'
  spec.description   =
    'A simple Ruby gem which provides Issuer Response Code descriptions and suggestions for cardholders and merchants'
  spec.homepage      = 'https://github.com/espago/issuer_response_codes'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/espago/issuer_response_codes'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'sorbet-runtime', '~> 0.5'
end
