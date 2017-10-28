# frozen_string_literal: true

module LanguageServerRails
  class ContentContext
    attr_reader :content, :line_no, :character_no

    def initialize(content, line_no, character_no)
      @content = content
      @line_no = line_no
      @character_no = character_no
    end

    def cursor_text
      line = lines[line_no]
      binding.pry
    end

    private

    def lines
      @lines ||= content.body.split("\n")
    end
  end
end
