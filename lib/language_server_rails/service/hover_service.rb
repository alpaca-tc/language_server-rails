# frozen_string_literal: true

module LanguageServerRails
  module Service
    class HoverService < BaseService
      def do_hover
        uri_str = params.dig(:params, :textDocument, :uri)
        content = Content.new(uri_str)
        content_context = ContentContext.new(content, params.dig(:params, :position, :line), params.dig(:params, :position, :character))

        LanguageServerRails.logger.debug(content_context.cursor_text)

        contents = collect_hover_contents(content_context)

        if contents.empty?
          Interface::Hover.new(contents: [])
        else
          Interface::Hover.new(
            contents: contents,
            range: Interface::Range.new(
              start: Interface::Position.new(
                line: content_context.cursor_range.line,
                character: content_context.cursor_range.column
              ),
              end: Interface::Position.new(
                line: content_context.cursor_range.last_line,
                character: content_context.cursor_range.last_column
              )
            )
          )
        end
      end

      private

      def collect_hover_contents(content_context)
        result = project.client.run(id: @params[:id], command: 'find_definition', script: content_context.cursor_context)

        if result && @params[:id] == result[:id] && result[:status] == 'success'
          path, line = result[:data]
          SourceCode.new(path, line).hover
        else
          []
        end
      end
    end
  end
end
