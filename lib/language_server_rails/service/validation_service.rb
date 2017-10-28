# frozen_string_literal: true

module LanguageServerRails
  module Service
    class ValidationService < BaseService
      def do_validation
        diagnostics = [
          Protocol::Interface::Diagnostic.new(
            message: 'messageだよ',
            severity: Constant::DiagnosticSeverity::WARNING,
            range: Interface::Range.new(
              start: Interface::Position.new(
                line: 0,
                character: 0
              ),
              end: Interface::Position.new(
                line: 0,
                character: 0
              )
            )
          )
        ]

        {
          method: :"textDocument/publishDiagnostics",
          params: Protocol::Interface::PublishDiagnosticsParams.new(
            uri: uri,
            diagnostics: diagnostics
          )
        }
      end
    end
  end
end
