# frozen_string_literal: true

module Deepgram
  module Management
    # Client class for interacting with Deepgram's Management API,
    # allowing management of projects, keys, members, and more.
    class Client < Base
      # Sets up the API endpoint and headers for JSON content type.
      def initialize
        super
        @connection.path_prefix = 'v1/projects'
        @connection.headers['Content-Type'] = 'application/json'
      end

      # Projects

      # Retrieves all projects.
      # @return [Deepgram::Management::Response] The response object containing projects data.
      def projects
        request(:get)
      end

      # Retrieves a specific project by ID.
      # @param id [String] The project ID.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The response object containing the project data.
      def get_project(id, **kwargs)
        request(:get, id, **kwargs)
      end

      # Updates the name of a specific project.
      # @param id [String] The project ID.
      # @param name [String] The new name for the project.
      # @return [Deepgram::Management::Response] The response object containing the updated project data.
      def update_project(id, name:)
        request(:patch, id) do |request|
          request.body = JSON.generate(name: name)
        end
      end

      # Deletes a specific project.
      # @param id [String] The project ID.
      # @return [nil] Indicates the project has been successfully deleted.
      def delete_project(id)
        request(:delete, id)
      end

      # Keys

      # Lists all keys for a project.
      # @param project_id [String] The project ID.
      # @return [Deepgram::Management::Response] The response object containing keys data.
      def keys(project_id:)
        request(:get, "#{project_id}/keys")
      end

      # Retrieves a specific key by key ID for a project.
      # @param key_id [String] The key ID.
      # @param project_id [String] The project ID.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The response object containing the key data.
      def get_key(key_id, project_id:, **kwargs)
        request(:get, "#{project_id}/keys/#{key_id}", **kwargs)
      end

      # Creates a new key for a project.
      # @param project_id [String] The project ID.
      # @param comment [String] Comment or description for the key.
      # @param scopes [Array] Scopes or permissions assigned to the key.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The response object containing the new key data.
      def create_key(project_id:, comment:, scopes:, **kwargs)
        request(:post, "#{project_id}/keys", **kwargs) do |request|
          request.body = JSON.generate(comment: comment, scopes: scopes)
        end
      end

      # Deletes a specific key for a project.
      # @param key_id [String] The key ID.
      # @param project_id [String] The project ID.
      # @return [nil] Indicates the key has been successfully deleted.
      def delete_key(key_id, project_id:)
        request(:delete, "#{project_id}/keys/#{key_id}")
      end

      # Members

      # Lists all members of a project.
      # @param project_id [String] The project ID.
      # @return [Deepgram::Management::Response] The response object containing members data.
      def members(project_id:)
        request(:get, "#{project_id}/members")
      end

      # Removes a specific member from a project.
      # @param member_id [String] The member ID.
      # @param project_id [String] The project ID.
      # @return [nil] Indicates the member has been successfully removed.
      def remove_member(member_id, project_id:)
        request(:delete, "#{project_id}/members/#{member_id}")
      end

      # Retrieves scopes for a specific member of a project.
      # @param project_id [String] The project ID.
      # @param member_id [String] The member ID.
      # @return [Deepgram::Management::Response] The response object containing member's scopes data.
      def member_scopes(project_id:, member_id:)
        request(:get, "#{project_id}/members/#{member_id}/scopes")
      end

      # Updates the scopes for a specific member of a project.
      # @param scope [Array] The new scopes for the member.
      # @param project_id [String] The project ID.
      # @param member_id [String] The member ID.
      # @return [Deepgram::Management::Response] The response object indicating the update was successful.
      def update_scope(scope, project_id:, member_id:)
        request(:put, "#{project_id}/members/#{member_id}/scopes") do |request|
          request.body = JSON.generate(scope: scope)
        end
      end

      # Invitations

      # Lists all invites for a project.
      # @param project_id [String] The project ID.
      # @return [Deepgram::Management::Response] The response object containing invites data.
      def invites(project_id:)
        request(:get, "#{project_id}/invites")
      end

      # Sends an invite to join a project.
      # @param email [String] The email address of the invitee.
      # @param project_id [String] The project ID.
      # @param scope [Array] The scopes assigned to the invitee upon acceptance.
      # @return [Deepgram::Management::Response] The response object indicating the invite was sent.
      def send_invite(email:, project_id:, scope:)
        request(:post, "#{project_id}/invites") do |request|
          request.body = JSON.generate(email: email, scope: scope)
        end
      end

      # Deletes an invite for a project.
      # @param email [String] The email address of the invitee.
      # @param project_id [String] The project ID.
      # @return [nil] Indicates the invite has been successfully deleted.
      def delete_invite(email, project_id:)
        request(:delete, "#{project_id}/invites/#{email}")
      end

      # Allows a member to leave a project.
      # @param project_id [String] The project ID.
      # @return [nil] Indicates the member has left the project.
      def leave_project(project_id:)
        request(:delete, "#{project_id}/leave")
      end

      # Requests

      # Lists all requests for a project.
      # @param project_id [String] The project ID.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The response object containing requests data.
      def requests(project_id:, **kwargs)
        request(:get, "#{project_id}/requests", **kwargs)
      end

      # Retrieves a specific request for a project.
      # @param request_id [String] The request ID.
      # @param project_id [String] The project ID.
      # @return [Deepgram::Management::Response] The response object containing the request data.
      def get_request(request_id, project_id:)
        request(:get, "#{project_id}/requests/#{request_id}")
      end

      # Usage

      # Retrieves usage information for a project.
      # @param project_id [String] The project ID.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The response object containing usage data.
      def usage(project_id:, **kwargs)
        request(:get, "#{project_id}/usage", **kwargs)
      end

      # Retrieves the available fields for usage data for a project.
      # @param project_id [String] The project ID.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The response object containing fields data.
      def fields(project_id:, **kwargs)
        request(:get, "#{project_id}/usage/fields", **kwargs)
      end

      # Balances

      # Lists all balances for a project.
      # @param project_id [String] The project ID.
      # @return [Deepgram::Management::Response] The response object containing balances data.
      def balances(project_id:)
        request(:get, "#{project_id}/balances")
      end

      # Retrieves a specific balance for a project.
      # @param balance_id [String] The balance ID.
      # @param project_id [String] The project ID.
      # @return [Deepgram::Management::Response] The response object containing the balance data.
      def balance(balance_id, project_id:)
        request(:get, "#{project_id}/balances/#{balance_id}")
      end

      private

      # Extends the Base class's request method to wrap the response in a Management::Response object.
      # @param method [Symbol] The HTTP method.
      # @param path [String] The endpoint path.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Management::Response] The wrapped response object.
      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    # Encapsulates the response from the Management API, providing methods to access various response data.
    class Response
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      # Parses the response body as JSON and returns the raw data.
      def raw
        JSON.parse(@body)
      end

      # Methods for accessing specific parts of the response data, such as projects, keys, members, etc.
      # Each method parses the raw JSON data and returns the relevant section, e.g., `raw['projects']` for `projects`.

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

      def balances
        raw['balances']
      end

      def distribution_credentials
        raw['distribution_credentials']
      end
    end
  end
end
