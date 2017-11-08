# frozen_string_literal: true

module LanguageServerRails
  module Service
    class DefinitionService < BaseService
      def do_definition
        uri_str = params.dig(:params, :textDocument, :uri)
        content = Content.new(uri_str)
        content_context = ContentContext.new(content, params.dig(:params, :position, :line), params.dig(:params, :position, :character))

        LanguageServerRails.logger.debug(content_context.cursor_text)

        find_definitions(content_context)
      end

      private

      def find_definitions(content_context)
        result = project.client.run(id: @params[:id], command: 'find_definition', script: content_context.cursor_context)

        return unless result && @params[:id] == result[:id] && result[:status] == 'success'

        path, line, character = result[:data]
        return unless File.exist?(path)

        Interface::Location.new(
          uri: "file://#{path}",
          range: Interface::Range.new(
            start: Interface::Position.new(
              line: line,
              character: character
            ),
            end: Interface::Position.new(
              line: 0,
              character: 0
            )
          )
        )
      end
    end
  end
end
