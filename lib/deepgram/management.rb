# frozen_string_literal: true

module Deepgram
  module Management
    # The Client class provides an interface for interacting with the Deepgram Management API.
    class Client < Base
      def initialize
        super
        @connection.path_prefix = 'v1/projects'
        @connection.headers['Content-Type'] = 'application/json'
      end

      # projects

      def projects
        request(:get)
      end

      def get_project(id, **kwargs)
        request(:get, id, **kwargs)
      end

      def update_project(id, name:)
        request(:patch, id, name: name)
      end

      def delete_project(id)
        request(:delete, id)
      end

      # keys

      def keys(project_id:)
        request(:get, "#{project_id}/keys")
      end

      def get_key(key_id, project_id:, **kwargs)
        request(:get, "#{project_id}/keys#{key_id}", **kwargs)
      end

      def create_key(project_id:, comment:, scopes:, **kwargs)
        request(:post, "#{project_id}/keys", comment: comment, scopes: scopes, **kwargs)
      end

      def delete_key(key_id, project_id:)
        request(:delete, "#{project_id}/keys/#{key_id}")
      end

      # members

      def members(project_id:)
        request(:get, "#{project_id}/members")
      end

      def remove_member(member_id, project_id:)
        request(:delete, "#{project_id}/members/#{member_id}")
      end

      def member_scopes(project_id:, member_id:)
        request(:get, "#{project_id}/members/#{member_id}/scopes")
      end

      def update_scope(scope, project_id:, member_id:)
        request(:put, "#{project_id}/members/#{member_id}/scopes", scope: scope)
      end

      # invitations

      def invites(project_id:)
        request(:get, "#{project_id}/invites")
      end

      def send_invite(email:, project_id:, scope:)
        request(:post, "#{project_id}/invites", email: email, scope: scope)
      end

      def delete_invite(email, project_id:)
        request(:delete, "#{project_id}/invites/#{email}")
      end

      def leave_project(project_id:)
        request(:delete, "#{project_id}/leave")
      end

      # requests

      def requests(project_id:, **kwargs)
        request(:get, "#{project_id}/requests", **kwargs)
      end

      def get_request(request_id, project_id:)
        request(:get, "#{project_id}/requests/#{request_id}")
      end

      # usage

      def usage(project_id:, **kwargs)
        request(:get, "#{project_id}/usage", **kwargs)
      end

      def fields(project_id:, **kwargs)
        request(:get, "#{project_id}/usage/fields", **kwargs)
      end

      # balances

      def balances(project_id:)
        request(:get, "#{project_id}/balances")
      end

      def balance(balance_id, project_id:)
        request(:get, "#{project_id}/balances/#{balance_id}")
      end

      private

      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    class Response
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      def raw
        JSON.parse(@body)
      end

      def projects
        raw['projects']
      end

      def keys
        raw['api_keys']
      end

      def members
        raw['members']
      end

      def scopes
        raw['scopes']
      end

      def invites
        raw['invites']
      end

      def requests
        raw['requests']
      end
    end
  end
end
