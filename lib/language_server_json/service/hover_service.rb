module LanguageServerJson
  module Service
    class HoverService < BaseService
      def do_hover
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
