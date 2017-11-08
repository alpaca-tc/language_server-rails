# frozen_string_literal: true

module LanguageServerRails
  class SourceCode
    def initialize(path, line)
      @path = path
      @line = line
    end

    def hover
      "#{@path} L:#{@line}"
    end
  end
end
