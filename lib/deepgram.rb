# frozen_string_literal: true

# The Deepgram Ruby gem provides a simple and convenient way to interact
# with the Deepgram APIs for speech recognition, text-to-speech, and
# natural language processing tasks.
#
# This file serves as the main entry point for the gem and handles loading
# the necessary dependencies and modules.

require 'faraday'
require 'dotenv/load'

# Load version information
require_relative 'deepgram/version'

# Load base classes and modules
require_relative 'deepgram/base'
require_relative 'deepgram/listen'
require_relative 'deepgram/speak'
require_relative 'deepgram/read'

# The Deepgram module is the main namespace for the gem.
# It provides access to the various classes and modules
# for interacting with the Deepgram APIs.
module Deepgram
end
