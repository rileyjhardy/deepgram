# Deepgram Ruby Client

The Deepgram Ruby Client is a comprehensive library for interacting with the Deepgram API, allowing developers to easily integrate Deepgram's powerful speech recognition and processing capabilities into Ruby applications. This client covers various functionalities, including file transcription, real-time audio processing, and management of Deepgram projects and resources.

## Features

- **Transcription**: Transcribe audio files or live audio streams with support for various audio formats.
- **Text-to-Speech**: Convert text into natural-sounding speech, with support for asynchronous operations and callbacks.
- **Project Management**: Manage Deepgram projects, including project creation, deletion, and updates.
- **API Key Management**: Create, list, and delete API keys associated with your Deepgram projects.
- **Member Management**: Manage project members, their roles, and permissions.
- **Usage and Metrics**: Access detailed usage metrics and balance information for your Deepgram projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deepgram'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install deepgram
```

## Usage

### Initialization

```ruby
require 'deepgram'

# Initialize the client for different functionalities
read_client = Deepgram::Client.read
speak_client = Deepgram::Client.speak
listen_client = Deepgram::Client.listen
management_client = Deepgram::Client.management
on_prem_client = Deepgram::Client.on_prem
```

### Transcribing Audio Files

```ruby
response = listen_client.transcribe_file(path: 'path/to/your/audio_file.wav')
puts response.transcript
```

### Converting Text to Speech

```ruby
response = speak_client.speak(text: 'Hello, world!')
# Save the speech file or process further
```

### Managing Projects

```ruby
# List all projects
projects = management_client.projects

# Create a new API key for a project
key_response = management_client.create_key(project_id: 'your_project_id', comment: 'New key', scopes: ['full_access'])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at [your-github-repo-link]. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of Conduct

Everyone interacting in the DeepgramRubyClient project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).
