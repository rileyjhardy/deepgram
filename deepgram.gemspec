# frozen_string_literal: true

require_relative 'lib/deepgram/version'

Gem::Specification.new do |spec|
  spec.name = 'deepgram'
  spec.version = Deepgram::VERSION
  spec.authors = ['Riley Hardy']
  spec.email = ['54298858+rileyjhardy@users.noreply.github.com']
  spec.summary = 'Deepgram API Client'
  spec.description = 'Ruby toolkit for Deepgram API https://www.deepgram.com'
  spec.homepage = 'https://github.com/rileyjhardy/deepgram'
  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.9'
  spec.add_development_dependency 'dotenv', '~> 3.1'
  spec.add_development_dependency 'guard', '~> 2.18'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'guard-rubocop', '~> 1.5'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.62'
end
