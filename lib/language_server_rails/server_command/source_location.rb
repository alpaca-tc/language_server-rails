# frozen_string_literal: true

module LanguageServerRails
  module ServerCommand
    class SourceLocation
      def self.build_server_script(_string)
        'LanguageServerRails::ServerCommand::SourceLocation.method(:build_server_script).source_location'
      end
    end
  end
end
