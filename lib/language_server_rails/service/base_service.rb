# frozen_string_literal: true

require 'language_server-protocol'

module LanguageServerRails
  module Service
    class BaseService
      Interface = LanguageServer::Protocol::Interface
      Constant = LanguageServer::Protocol::Constant

      attr_reader :params, :project

      def initialize(project, params)
        @project = project
        @params = params
      end
    end
  end
end
