# frozen_string_literal: true

module Deepgram
  module OnPrem
    # The Client class within the OnPrem module extends the Management::Client class
    # to handle operations specific to on-premise deployments within the Deepgram platform.
    class Client < Management::Client
      # Retrieves a list of credentials for a given project.
      #
      # @param project_id [String] The unique identifier for the project.
      # @return [Array] A list of credentials associated with the specified project.
      def credentials(project_id:)
        request(:get, "#{project_id}/onprem/distribution/credentials")
      end

      # Retrieves a specific credential by its ID within a given project.
      #
      # @param id [String] The unique identifier for the credential.
      # @param project_id [String] The unique identifier for the project.
      # @return [Hash] The details of the specified credential.
      def get_credential(id, project_id:)
        request(:get, "#{project_id}/onprem/distribution/credentials/#{id}")
      end

      # Creates a new credential within a project with the specified details.
      #
      # @param comments [String] Descriptive comments about the credential.
      # @param scopes [Array] The scopes or permissions assigned to the credential.
      # @param provider [String] The provider or platform for which the credential is valid.
      # @param project_id [String] The unique identifier for the project.
      # @return [Hash] The details of the newly created credential.
      def create_credential(comments:, scopes:, provider:, project_id:)
        request(:post, "#{project_id}/onprem/distribution/credentials") do |request|
          request.body = JSON.generate(comments: comments, scopes: scopes, provider: provider)
        end
      end

      # Deletes a specific credential by its ID from a given project.
      #
      # @param id [String] The unique identifier for the credential to be deleted.
      # @param project_id [String] The unique identifier for the project.
      # @return [nil] Indicates the credential has been successfully deleted.
      def delete_credential(id, project_id:)
        request(:delete, "#{project_id}/onprem/distribution/credentials/#{id}")
      end
    end
  end
end
