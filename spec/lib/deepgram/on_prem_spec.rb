# frozen_string_literal: true

require 'spec_helper'
require 'rspec'
require 'deepgram/fixtures'

RSpec.describe Deepgram::OnPrem::Client do
  describe 'credentials' do
    let(:client) { described_class.new }

    it '#credentials' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('credentials.json'), headers: {})

      res = client.credentials(project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:get,
                       'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials')).to have_been_made
    end

    it '#get_credential' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials/5678')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('credential.json'), headers: {})

      res = client.get_credential('5678', project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials/5678'))
        .to have_been_made
    end

    it '#create_credentials' do
      stub_request(:post, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials')
        .with(
          body: JSON.generate(comments: 'Dev credentials', scopes: %w[read write], provider: 'quay')
        )
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('credential.json'), headers: {})

      res = client.create_credential(
        comments: 'Dev credentials', scopes: %w[read write], provider: 'quay', project_id: '1234'
      )

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:post, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials'))
        .to have_been_made
    end

    it '#delete_credential' do
      stub_request(:delete, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials/5678')
        .to_return(status: 200, body: JSON.generate(
          message: 'Successfully deleted the distribution credentials!'
        ), headers: {})

      res = client.delete_credential('5678', project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:delete, 'https://api.deepgram.com/v1/projects/1234/onprem/distribution/credentials/5678'))
        .to have_been_made
    end
  end
end
