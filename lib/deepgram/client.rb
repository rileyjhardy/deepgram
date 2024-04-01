# frozen_string_literal: true

module Deepgram
  # The Client module serves as a factory for creating instances of various
  # specialized client classes within the Deepgram module. Each client class
  # is tailored to interact with a specific part of the Deepgram API.
  module Client
    # Creates a new instance of the Read::Client class.
    #
    # @return [Deepgram::Read::Client] A client for interacting with the Deepgram Read API.
    def self.read
      Read::Client.new
    end

    # Creates a new instance of the Speak::Client class.
    #
    # @return [Deepgram::Speak::Client] A client for interacting with the Deepgram Speak API.
    def self.speak
      Speak::Client.new
    end

    # Creates a new instance of the Listen::Client class.
    #
    # @return [Deepgram::Listen::Client] A client for interacting with the Deepgram Listen API.
    def self.listen
      Listen::Client.new
    end

    # Creates a new instance of the Management::Client class.
    #
    # @return [Deepgram::Management::Client] A client for managing resources within the Deepgram platform.
    def self.management
      Management::Client.new
    end

    # Creates a new instance of the OnPrem::Client class.
    #
    # @return [Deepgram::OnPrem::Client] A client for managing on-premise deployments within the Deepgram platform.
    def self.on_prem
      OnPrem::Client.new
    end
  end
end
