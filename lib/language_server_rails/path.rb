# frozen_string_literal: true

module LanguageServerRails
  module Path
    def self.executable?(executable)
      quote = '"'

      ENV['PATH'].to_s.split(File::PATH_SEPARATOR).any? do |path|
        path = path[1..-2] if path.start_with?(quote) && path.end_with?(quote)
        executable_path = File.expand_path(executable, path)
        File.file?(executable_path) && File.executable?(executable_path)
      end
    end
  end
end
