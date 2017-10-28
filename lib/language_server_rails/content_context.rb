# frozen_string_literal: true

require 'parser/current'

module LanguageServerRails
  class ContentContext
    attr_reader :content, :line_no, :character_no

    def initialize(content, line_no, character_no)
      @content = content
      @line_no = line_no
      @character_no = character_no
    end

    def cursor_text
      location = cursor_node.location
      lines[line_no - 1][location.keyword.column...location.keyword.last_column]
    end

    private

    def cursor_node
      @cursor_node ||= find_node(parsed)
    end

    def find_node(node)
      location = node.location

      if location.first_line == line_no && (location.keyword.column..location.keyword.last_column).include?(character_no)
        return node
      else
        binding.pry
      end
    end

    def parsed
      @parsed ||= Parser::CurrentRuby.parse(content.body)
    end

    def lines
      @lines ||= content.body.split("\n")
    end
  end
end
