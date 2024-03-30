# frozen_string_literal: true

module Deepgram
  module OnPrem
    class Client < Management::Client
      def credentials(project_id:)
        request(:get, "#{project_id}/onprem/distribution/credentials")
      end

      def get_credential(id, project_id:)
        request(:get, "#{project_id}/onprem/distribution/credentials/#{id}")
      end

      def create_credential(comments:, scopes:, provider:, project_id:)
        request(:post, "#{project_id}/onprem/distribution/credentials") do |request|
          request.body = JSON.generate(comments: comments, scopes: scopes, provider: provider)
        end
      end

      def delete_credential(id, project_id:)
        request(:delete, "#{project_id}/onprem/distribution/credentials/#{id}")
      end
    end
  end
end
