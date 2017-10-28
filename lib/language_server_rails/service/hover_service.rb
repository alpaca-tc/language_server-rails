module LanguageServerRails
  module Service
    class HoverService < BaseService
      def do_hover
        require 'pry-remote'
        uri_str = params.dig(:params, :textDocument, :uri)
        content = Content.new(uri_str)
        binding.remote_pry;

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

    class Content
      def initialize(raw_uri)
        @raw_uri = raw_uri
        @uri = URI(raw_uri)
      end

      def exists?
        case @uri.scheme
        when 'file'
          File.exists?(@uri.path)
        else
          raise NotImplementedError, 'not implemented yet'
        end
      end

      def content
        @content ||= case @uri.scheme
                     when 'file'
                       File.read(@uri.path)
                     else
                       raise NotImplementedError, 'not implemented yet'
                     end
      end
    end
  end
end
