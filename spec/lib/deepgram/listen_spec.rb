# frozen_string_literal: true

require 'spec_helper'
require 'rspec'
require 'deepgram/fixtures'

RSpec.describe Deepgram::Listen::Client do
  describe 'listen client' do
    let(:client) { described_class.new }
    let(:harvard) { Deepgram::Fixtures.load_file('harvard.json') }
    let(:file) { Deepgram::Fixtures.load_file('harvard.wav') }

    it 'raises an error if the file does not exist' do
      expect { client.transcribe_file(path: 'nonexistent.wav') }.to raise_error(ArgumentError, /Invalid file path/)
    end

    it 'raises an error if the URL is invalid' do
      expect { client.transcribe_url(url: 'invalid') }.to raise_error(ArgumentError, /Invalid URL/)
    end

    it '#transcribe_file' do
      stub_request(:post, 'https://api.deepgram.com/v1/listen')
        .with(
          body: File.binread('spec/fixtures/harvard.wav'),
          headers: {
            'Content-Type' => 'audio/wav'
          }
        )
        .to_return(status: 200, body: harvard, headers: {})

      res = client.transcribe_file(path: 'spec/fixtures/harvard.wav')

      expect(res.transcript).to eq('the stale smell of old beer lingers it takes heat to bring out ' \
      'the odor a cold dip restores health and zest a salt pickle tastes fine with ham a tacos all ' \
      'pasteur are my favorite a zest food is the hot cross bun')
      expect(res.words.count).to eq(44)
      expect(res).to be_a(Deepgram::Listen::Response)
    end

    it '#transcribe_url' do
      stub_request(:post, 'https://api.deepgram.com/v1/listen')
        .with(body: JSON.generate(url: 'https://example.com/harvard.wav'))
        .to_return(status: 200, body: file, headers: {})

      res = client.transcribe_url(url: 'https://example.com/harvard.wav')

      expect(res).to be_a(Deepgram::Listen::Response)
      expect(a_request(:post, 'https://api.deepgram.com/v1/listen')).to have_been_made
    end
  end
end
