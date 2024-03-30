# frozen_string_literal: true

module Deepgram
  module Client
    def self.read
      Read::Client.new
    end

    def self.speak
      Speak::Client.new
    end

    def self.listen
      Listen::Client.new
    end

    def self.management
      Management::Client.new
    end

    def self.on_prem
      OnPrem::Client.new
    end
  end
end
