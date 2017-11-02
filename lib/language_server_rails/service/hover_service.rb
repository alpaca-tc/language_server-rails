# frozen_string_literal: true

module LanguageServerRails
  module Service
    class HoverService < BaseService
      def do_hover
        uri_str = params.dig(:params, :textDocument, :uri)
        content = Content.new(uri_str)
        content_context = ContentContext.new(content, params.dig(:params, :position, :line), params.dig(:params, :position, :character))

        contents, range = if content_context.cursor_range
                            [
                              collect_hover_contents(content_context),
                              Interface::Range.new(
                                start: Interface::Position.new(
                                  line: content_context.cursor_range.line,
                                  character: content_context.cursor_range.column
                                ),
                                end: Interface::Position.new(
                                  line: content_context.cursor_range.last_line,
                                  character: content_context.cursor_range.last_column
                                )
                              )
                            ]
                          else
                            [[], nil]
                          end

        LanguageServerRails.logger.debug(content_context.cursor_text)

        Interface::Hover.new(
          contents: contents,
          range: range
        )
      end

      private

      def collect_hover_contents(content_context)
        [content_context.cursor_text]
      end
    end
  end
end
