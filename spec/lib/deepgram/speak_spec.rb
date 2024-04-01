# frozen_string_literal: true

require 'spec_helper'
require 'rspec'
require 'deepgram/fixtures'

RSpec.describe Deepgram::Speak::Client do
  describe 'speak client' do
    let(:client) { described_class.new }
    let(:text_input) { Deepgram::Fixtures.load_file('pencils.txt') }
    let(:audio) { Deepgram::Fixtures.load_file('pencils_dictation.mp3') }

    it '#speak' do
      stub_request(:post, 'https://api.deepgram.com/v1/speak')
        .with(
          body: JSON.generate({ text: text_input }),
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.0'
          }
        )
        .to_return(status: 200, body: audio, headers: {})

      res = client.speak(text: text_input)

      expect(res).to be_a(Deepgram::Speak::Response)
      expect(a_request(:post, 'https://api.deepgram.com/v1/speak')).to have_been_made
    end

    it '#speak_async' do
      stub_request(:post, 'https://api.deepgram.com/v1/speak?callback_url=https://example.com')
        .with(
          body: JSON.generate({ text: text_input }),
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.0'
          }
        )
        .to_return(status: 200, body: {
          "request_id": '9448b2de-e67b-4af2-ab88-131545589d2f'
        }.to_json, headers: {})

      res = client.speak_async(text: text_input, callback_url: 'https://example.com')

      expect(res).to be_a(Deepgram::Speak::Response)
      expect(res.request_id).to eq('9448b2de-e67b-4af2-ab88-131545589d2f')
      expect(a_request(:post, 'https://api.deepgram.com/v1/speak?callback_url=https://example.com')).to have_been_made
    end
  end
end
