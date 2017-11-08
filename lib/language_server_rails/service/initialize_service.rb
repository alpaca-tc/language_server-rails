# frozen_string_literal: true

module LanguageServerRails
  module Service
    class InitializeService < BaseService
      def do_initialize
        Interface::InitializeResult.new(
          capabilities: Interface::ServerCapabilities.new(
            text_document_sync: Interface::TextDocumentSyncOptions.new(
              change: Constant::TextDocumentSyncKind::NONE
            ),
            completion_provider: Interface::CompletionOptions.new(
              resolve_provider: false
            ),
            definition_provider: true
          )
        )
      end
    end
  end
end
