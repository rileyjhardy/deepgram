require 'spec_helper'
require 'rspec'
require 'deepgram/fixtures'

RSpec.describe Deepgram::Listen::Client do
  describe '#transcribe_file' do
    let(:client) { described_class.new }
    let(:fixture) { Deepgram::Fixtures.load_json('harvard.json')}

    it 'raises an error if the file does not exist' do
      expect {
        client.transcribe_file(path: 'nonexistent.wav')
      }.to raise_error(ArgumentError, /Invalid file path/)
    end

    it 'sends a POST request with the file as the body' do
      stub_request(:post, 'https://api.deepgram.com/v1/listen')
        .with(
          body: File.binread('spec/fixtures/harvard.wav'),
          headers: {
            'Content-Type' => 'audio/wav',
          })
        .to_return(status: 200, body: fixture.to_json, headers: {})

      res = client.transcribe_file(path: 'spec/fixtures/harvard.wav')

      expect(res.transcript).to eq('the stale smell of old beer lingers it takes heat to bring out the odor a cold dip restores health and zest a salt pickle tastes fine with ham a tacos all pasteur are my favorite a zest food is the hot cross bun')
      expect(res.words.count).to eq(44)
      expect(res).to be_a(Deepgram::Listen::Response)
    end
  end

  describe '#transcribe_url' do
    let(:client) { described_class.new }
    let(:file) { Deepgram::Fixtures.load_file('harvard.wav')}

    it 'raises an error if the URL is invalid' do
      expect {
        client.transcribe_url(url: 'invalid')
      }.to raise_error(ArgumentError, /Invalid URL/)
    end

    it 'sends a POST request with the URL as the body' do
      stub_request(:post, 'https://api.deepgram.com/v1/listen')
        .with(body: JSON.generate(url: 'https://example.com/harvard.wav'))
        .to_return(status: 200, body: file, headers: {})

      res = client.transcribe_url(url: 'https://example.com/harvard.wav')

      expect(res).to be_a(Deepgram::Listen::Response)
      expect(a_request(:post, 'https://api.deepgram.com/v1/listen')).to have_been_made
    end
  end
end
