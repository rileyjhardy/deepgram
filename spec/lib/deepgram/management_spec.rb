# frozen_string_literal: true

require 'spec_helper'
require 'rspec'
require 'deepgram/fixtures'

RSpec.describe Deepgram::Management::Client do
  describe 'projects' do
    let(:client) { described_class.new }

    it '#projects' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects')
        .to_return(status: 200, body: {
          "projects": [
            {
              "project_id": '1234',
              "name": "developers@deepgram.com's Project"
            }
          ]
        }.to_json, headers: {})

      res = client.projects

      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.projects.count).to eq(1)
      expect(res.projects.first['project_id']).to eq('1234')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects')).to have_been_made
    end

    it '#get_project' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234')
        .to_return(status: 200, body: {
          "project_id": '1234',
          "name": 'Company Name'
        }.to_json, headers: {})

      res = client.get_project('1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234')).to have_been_made
    end

    it '#update_project' do
      stub_request(:patch, 'https://api.deepgram.com/v1/projects/1234')
        .with(body: { name: 'New Name' }.to_json)

      res = client.update_project('1234', name: 'New Name')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:patch, 'https://api.deepgram.com/v1/projects/1234')).to have_been_made
    end

    it '#delete_project' do
      stub_request(:delete, 'https://api.deepgram.com/v1/projects/1234')

      res = client.delete_project('1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:delete, 'https://api.deepgram.com/v1/projects/1234')).to have_been_made
    end
  end

  # keys

  describe 'keys' do
    let(:client) { described_class.new }

    it '#keys' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/keys')
        .to_return(status: 200, body: JSON.generate(
          api_keys: [
            {
              "member": {
                "member_id": 'b74f9a00-ea40-4585-951e-88e63c35108f',
                "email": 'devrel@deepgram.com',
                "first_name": 'Scott',
                "last_name": 'Stephenson'
              },
              "api_key": {
                "api_key_id": 'api-key-123',
                "comment": 'Management API key',
                "scopes": [
                  'owner'
                ],
                "created": '2021-05-30T12:24:33.564224Z'
              }
            }
          ]
        ), headers: {})

      res = client.keys(project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.keys.count).to eq(1)
      expect(res.keys.first['api_key']['api_key_id']).to eq('api-key-123')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/keys')).to have_been_made
    end

    it '#get_key' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/keys/5678')
        .to_return(status: 200, body: JSON.generate(
          member: {
            "member_id": 'b74f9a00-ea40-4585-951e-88e63c35108f',
            "email": 'devrel@deepgram.com',
            "first_name": 'Deepgram',
            "last_name": 'Team'
          },
          api_key: {
            "api_key_id": 'api-key-123',
            "comment": 'Member API key',
            "scopes": [
              'member'
            ],
            "tags": [
              'user'
            ],
            "created": '2021-06-01T14:03:35.815832Z'
          }
        ), headers: {})

      res = client.get_key('5678', project_id: '1234')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.raw['api_key']['api_key_id']).to eq('api-key-123')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/keys/5678')).to have_been_made
    end

    it '#create_key' do
      stub_request(:post, 'https://api.deepgram.com/v1/projects/1234/keys')
        .with(body: JSON.generate(comment: 'my new api key', scopes: ['member', 'onprem:products']))
        .to_return(status: 200, body: {
          "api_key_id": 'b6c318f0-bc94-40b3-83a9-7f6898cd5500',
          "key": '1bc4a5e63f8425c9fd102539739923204243b9ce',
          "comment": 'Test On-prem API Key with curl',
          "scopes": [
            'member',
            'onprem:product:api',
            'onprem:product:engine',
            'onprem:product:license-proxy'
          ],
          "created": '2023-06-27T16:59:46.572660Z'
        }.to_json)

      res = client.create_key(project_id: '1234', comment: 'my new api key', scopes: ['member', 'onprem:products'])

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:post, 'https://api.deepgram.com/v1/projects/1234/keys')).to have_been_made
    end

    it '#delete_key' do
      stub_request(:delete, 'https://api.deepgram.com/v1/projects/1234/keys/5678')

      res = client.delete_key('5678', project_id: '1234')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:delete, 'https://api.deepgram.com/v1/projects/1234/keys/5678')).to have_been_made
    end
  end

  describe 'members' do
    let(:client) { described_class.new }

    it '#members' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/members')
        .to_return(status: 200, body: JSON.generate(
          members: [
            {
              "member_id": 'member-id-123',
              "first_name": 'string',
              "last_name": 'string',
              "scopes": [
                'string'
              ],
              "email": 'string'
            }
          ]
        ))

      res = client.members(project_id: '1234')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.members.count).to eq(1)
      expect(res.members.first['member_id']).to eq('member-id-123')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/members')).to have_been_made
    end

    it '#remove_member' do
      stub_request(:delete, 'https://api.deepgram.com/v1/projects/1234/members/5678')

      res = client.remove_member('5678', project_id: '1234')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:delete, 'https://api.deepgram.com/v1/projects/1234/members/5678')).to have_been_made
    end

    it '#member_scopes' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/members/5678/scopes')
        .to_return(status: 200, body: JSON.generate(
          scopes: [
            'member'
          ]
        ))

      res = client.member_scopes(project_id: '1234', member_id: '5678')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/members/5678/scopes')).to have_been_made
    end

    it '#update_scope' do
      stub_request(:put, 'https://api.deepgram.com/v1/projects/1234/members/5678/scopes')
        .with(body: JSON.generate({ scope: 'nonmember' }))

      res = client.update_scope('nonmember', project_id: '1234', member_id: '5678')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:put, 'https://api.deepgram.com/v1/projects/1234/members/5678/scopes')).to have_been_made
    end
  end

  describe 'invitations' do
    let(:client) { described_class.new }

    it '#invites' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/invites')
        .to_return(status: 200, body: JSON.generate(
          invites: [
            {
              "email": 'test@example.com',
              "scope": 'member'
            }
          ]
        ))

      res = client.invites(project_id: '1234')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.invites.count).to eq(1)
      expect(res.invites.first['email']).to eq('test@example.com')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/invites')).to have_been_made
    end

    it '#delete_invite' do
      stub_request(:delete, 'https://api.deepgram.com/v1/projects/1234/invites/test@example.com')

      res = client.delete_invite('test@example.com', project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:delete, 'https://api.deepgram.com/v1/projects/1234/invites/test@example.com')).to have_been_made
    end

    it '#send_invitation' do
      stub_request(:post, 'https://api.deepgram.com/v1/projects/1234/invites')
        .with(body: JSON.generate({ email: 'test@example.com', scope: 'member' }))

      res = client.send_invite(email: 'test@example.com', project_id: '1234', scope: 'member')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:post, 'https://api.deepgram.com/v1/projects/1234/invites')).to have_been_made
    end

    it '#leave_project' do
      stub_request(:delete, 'https://api.deepgram.com/v1/projects/1234/leave')

      res = client.leave_project(project_id: '1234')
      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:delete, 'https://api.deepgram.com/v1/projects/1234/leave')).to have_been_made
    end
  end
  describe 'usage' do
    let(:client) { described_class.new }

    it '#requests' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/requests')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('requests.json'), headers: {})

      res = client.requests(project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.requests.count).to eq(1)
      expect(res.requests.first['request_id']).to eq 'request-id-123'
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/requests')).to have_been_made
    end

    it '#get_request' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/requests/5678')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('request.json'), headers: {})

      res = client.get_request('5678', project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)

      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/requests/5678')).to have_been_made
    end

    it '#usage' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/usage')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('usage.json'), headers: {})

      res = client.usage(project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/usage')).to have_been_made
    end

    it '#fields' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/usage/fields')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('fields.json'), headers: {})

      res = client.fields(project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/usage/fields')).to have_been_made
    end
  end

  describe 'billing' do
    let(:client) { described_class.new }

    it '#balances' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/balances')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('balances.json'), headers: {})

      res = client.balances(project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.balances.count).to eq(1)
      expect(res.balances.first['balance_id']).to eq('balance-id-123')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/balances')).to have_been_made
    end

    it '#balance' do
      stub_request(:get, 'https://api.deepgram.com/v1/projects/1234/balances/5678')
        .to_return(status: 200, body: Deepgram::Fixtures.load_file('balance.json'), headers: {})

      res = client.balance('5678', project_id: '1234')

      expect(res).to be_a(Deepgram::Management::Response)
      expect(res.raw['balance_id']).to eq('balance-id-123')
      expect(a_request(:get, 'https://api.deepgram.com/v1/projects/1234/balances/5678')).to have_been_made
    end
  end
end
