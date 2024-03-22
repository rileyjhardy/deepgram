# Deepgram

A ruby client for interacting with the Deepgram API.

This is a test

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add deepgram

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install deepgram

## Usage

```
require 'deepgram'

# Setup the Deepgram client
deepgram = Deepgram::Listen::Client.new(api_key: 'YOUR_DEEPGRAM_API_KEY')

# Send an audio file for transcription
response = deepgram.transcribe_file(path: '/path/to/audio.wav')

# Or pass a url for an external file
response = deepgram.transcribe_url(url: 'https://example.com/audio.wav')

puts response.transcript # Print the transcribed text

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rileyjhardy/deepgram. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rileyjhardy/deepgram/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Deepgram project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rileyjhardy/deepgram/blob/main/CODE_OF_CONDUCT.md).
