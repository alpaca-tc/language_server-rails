# frozen_string_literal: true

module LanguageServerRails
  module Service
    class HoverService < BaseService
      def do_hover
        uri_str = params.dig(:params, :textDocument, :uri)
        content = Content.new(uri_str)
        binding.pry

        Interface::Hover.new(
          contents: 'hello contents',
          range: Interface::Range.new(
            start: Interface::Position.new(
              line: 0,
              character: 0
            ),
            end: Interface::Position.new(
              line: 1,
              character: 0
            )
          )
        )
      end
    end
  end
end
