# frozen_string_literal: true

require 'spec_helper'
require 'rspec'
require 'deepgram/fixtures'

RSpec.describe Deepgram::Read::Client do
  describe 'read client' do
    let(:client) { described_class.new }
    let(:text_input) { Deepgram::Fixtures.load_file('pencils.txt') }

    describe '#summarize' do
      let(:fixture) { Deepgram::Fixtures.load_file('summary.json') }

      it 'sends a POST request with the text as the body' do
        stub_request(:post, 'https://api.deepgram.com/v1/read?language=en&summarize=true')
          .with(
            body: JSON.generate({ text: text_input }),
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.9.0'
            }
          )
          .to_return(status: 200, body: fixture, headers: {})

        res = client.analyze(text: text_input, summarize: true)

        expect(res).to be_a(Deepgram::Read::Response)
        expect(res.metadata).to eq({
                                     'request_id' => '29e0c81a-3188-4d42-af53-1f7310a51de1',
                                     'created' => '2024-03-20T05:15:47.129Z',
                                     'language' => 'en',
                                     'summary_info' => {
                                       'model_uuid' => '67875a7f-c9c4-48a0-aa55-5bdb8a91c34a',
                                       'input_tokens' => 589,
                                       'output_tokens' => 88
                                     }
                                   })
        expect(res.summary).to eq('The speaker discusses the history and characteristics of the ' \
        'Fascinating World ofGeneration, a world filled with technological innovations. They explore ' \
        'the world of pencils, including the origins of the name Fascinating World of Nosils and the ' \
        'artistry involved in making them. They also mention the importance of the graphite and clay ' \
        'components in making a great pencil and encourage viewers to take a moment to appreciate its ' \
        'rich history and artistry.')
        expect(a_request(:post, 'https://api.deepgram.com/v1/read?language=en&summarize=true')).to have_been_made
      end
    end

    describe '#topics' do
      let(:fixture) { Deepgram::Fixtures.load_file('topics.json') }

      it 'sends a POST request with the text as the body' do
        stub_request(:post, 'https://api.deepgram.com/v1/read?language=en&topics=true')
          .with(
            body: JSON.generate({ text: text_input }),
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.9.0'
            }
          )
          .to_return(status: 200, body: fixture, headers: {})

        client = described_class.new
        res = client.analyze(text: text_input, topics: true)

        expect(res).to be_a(Deepgram::Read::Response)
        expect(res.topics.count).to eq(4)
        expect(res.topics.first).to eq(
          {
            'text' => "The Origins of the Pencil The pencil's origins can be traced back to " \
            'ancient times when the Romans and Egyptians used a form of lead ore known as plumbago ' \
            "to mark and write. However, it wasn't until the late 16th century that the modern pencil " \
            'began to take shape.',
            'start_word' => 49,
            'end_word' => 97,
            'topics' => [
              {
                'topic' => 'Inventing pencils',
                'confidence_score' => 0.0062142727
              }
            ]
          }
        )
        expect(a_request(:post, 'https://api.deepgram.com/v1/read?language=en&topics=true')).to have_been_made
      end
    end

    describe '#sentiment' do
      let(:fixture) { Deepgram::Fixtures.load_file('sentiment.json') }

      it 'sends a POST request with the text as the body' do
        stub_request(:post, 'https://api.deepgram.com/v1/read?language=en&sentiment=true')
          .with(
            body: JSON.generate({ text: text_input }),
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.9.0'
            }
          )
          .to_return(status: 200, body: fixture, headers: {})

        client = described_class.new
        res = client.analyze(text: text_input, sentiment: true)

        expect(res).to be_a(Deepgram::Read::Response)
        expect(res.sentiments.count).to eq(7)
        expect(res.sentiments.first).to eq(
          {
            'text' => "Let's Explore the Fascinating World of Pencils In a world filled with " \
            "technological marvels, it's easy to overlook the humble pencil. Yet, this unassuming " \
            'writing instrument has a rich history and a surprising depth of complexity.',
            'start_word' => 0,
            'end_word' => 35,
            'sentiment' => 'neutral',
            'sentiment_score' => 0.2861328125
          }
        )

        expect(a_request(:post, 'https://api.deepgram.com/v1/read?language=en&sentiment=true')).to have_been_made
      end
    end

    describe '#intents' do
      let(:fixture) { Deepgram::Fixtures.load_file('intents.json') }

      it 'sends a POST request with the text as the body' do
        stub_request(:post, 'https://api.deepgram.com/v1/read?language=en&intents=true')
          .with(
            body: JSON.generate({ text: text_input }),
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.9.0'
            }
          )
          .to_return(status: 200, body: fixture, headers: {})

        client = described_class.new
        res = client.analyze(text: text_input, intents: true)

        expect(res).to be_a(Deepgram::Read::Response)
        expect(res.intents.count).to eq(5)
        expect(res.intents.first).to eq(
          {
            'text' => 'Join us on a journey as we explore the fascinating world of pencils.',
            'start_word' => 36,
            'end_word' => 48,
            'intents' => [
              {
                'intent' => 'Propose journey',
                'confidence_score' => 0.00000372282
              }
            ]
          }
        )
        expect(a_request(:post, 'https://api.deepgram.com/v1/read?language=en&intents=true')).to have_been_made
      end
    end
  end
end
