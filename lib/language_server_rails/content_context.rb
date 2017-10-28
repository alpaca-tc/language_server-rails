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
      line = parsed.location.expression.source_buffer.source_lines[line_no - 1]

      case cursor_node.type
      when :module
        line[location.keyword.column...location.keyword.last_column]
      when :const
        line[location.column...location.last_column]
      else
        binding.pry
      end
    end

    def cursor_node
      @cursor_node ||= find_node(parsed)
    end

    private

    def find_node(node)
      return unless node

      location = node.location

      if location.first_line == line_no && (location.expression.column..location.expression.last_column).include?(character_no)
        return node
      elsif (location.first_line..location.last_line).include?(line_no)
        node.children.find do |child_node|
          find_node(child_node)
        end
      end
    rescue
      binding.pry
    end

    def parsed
      @parsed ||= Parser::CurrentRuby.parse(content.body)
    end

    def lines
      @lines ||= content.body.split("\n")
    end
  end
end
