# frozen_string_literal: true

require 'parser/current'

module LanguageServerRails
  class ContentContext
    ASSIGNMENT_TYPES = %i[lvasgn ivasgn gvasgn cvasgn casgn].freeze
    # PURE_OBJECT_TYPES = %i[int str dstr sym dsym regexp array hash].freeze
    PURE_OBJECT_TYPES = %i[int str sym regexp].freeze
    NodeDefinition = Struct.new(:node, :range, :parent_nodes)
    NAMESPACE_TYPES = %i[module class].freeze

    attr_reader :content, :line_no, :location_line_no, :character_no

    def initialize(content, line_no, character_no)
      @content = content
      @line_no = line_no
      @location_line_no = line_no + 1
      @character_no = character_no
      @cached_cursor_definitions = {}
    end

    def cursor_text
      cursor_range&.source
    end

    def cursor_context
      return unless cursor_node_definition

      context_names = cursor_node_definition.parent_nodes.map do |node|
        node.location.name.source
      end

      case cursor_node_definition.node.type
      when :def
        "#{context_names.join('::')}##{cursor_text}"
      when :send
        if cursor_node_definition.node.children[0]&.type == :const
          "#{context_names.join('::')}::#{cursor_node_definition.node.children[0].location.name.source}.#{cursor_text}"
        else
          "#{context_names.join('::')}##{cursor_text}"
        end
      else
        "#{context_names.join('::')}::#{cursor_text}"
      end
    end

    def cursor_range
      cursor_node_definition&.range
    end

    private

    def cursor_node_definition
      find_cached_cursor_definition(parsed)
    end

    # rubocop:disable all
    def extract_ranges_from_map(map)
      return [map.expression] if pure_object?(map.node)

      case map
      when Parser::Source::Map::Condition
        [map.keyword, map.begin, map.else, map.end]
      when Parser::Source::Map::Constant
        if assignment?(map.node)
          [map.double_colon, map.name, map.operator] # REVIEW: constantは全体を返す
        else
          [map.name, map.operator, map.expression] # REVIEW: constantは全体を返す
        end
      when Parser::Source::Map::Definition
        [map.end, map.keyword, map.name, map.operator]
      when Parser::Source::Map::For
        [map.begin, map.end, map.in, map.keyword]
      when Parser::Source::Map::Heredoc
        [map.heredoc_body, map.heredoc_end]
      when Parser::Source::Map::Collection
        if pure_object?(map.node)
          [map.begin, map.end, map.expression] # REVIEW: expressionが適切かどうか。
        else
          [map.begin, map.end]
        end
      when Parser::Source::Map::Keyword
        [map.keyword]
      when Parser::Source::Map::ObjcKwarg
        # no test
        [map.keyword, map.operator, map.argument]
      when Parser::Source::Map::Operator
        if pure_object?(map.node)
          [map.operator, map.expression] # REVIEW: expressionが適切かどうか。
        else
          [map.operator]
        end
      when Parser::Source::Map::RescueBody
        [map.keyword, map.assoc, map.begin]
      when Parser::Source::Map::Send
        [map.begin, map.dot, map.end, map.operator, map.selector]
      when Parser::Source::Map::Ternary
        [map.question, map.colon]
      when Parser::Source::Map::Variable
        [map.name, map.operator]
      when Parser::Source::Map
        [map.expression]
      else
        raise "unknown type given. (#{map.class})"
      end
    end
    # rubocop:enable all

    def assignment?(node)
      ASSIGNMENT_TYPES.include?(node.type)
    end

    def pure_object?(node)
      PURE_OBJECT_TYPES.include?(node.type)
    end

    def find_cached_cursor_definition(node)
      @cached_cursor_definitions.fetch(node) do
        @cached_cursor_definitions[node] = find_cursor_definition(node)
      end
    end

    def namespace?(node)
      NAMESPACE_TYPES.include?(node.type)
    end

    def find_cursor_definition(parent_node)
      nodes = [[[], [parent_node]]]

      until nodes.empty?
        next_nodes = []

        nodes.each do |(parents, children)|
          children.each do |node|
            next unless node.is_a?(Parser::AST::Node)
            next unless include_line?(node.location)

            ranges = extract_ranges_from_map(node.location).compact
            # binding.pry if current_line?(node.location) && defined?(RSpec)

            if current_range = ranges.find { |range| current_line?(range) && current_character?(range) }
              return NodeDefinition.new(node, current_range, parents)
            else
              parent_nodes = parents
              parent_nodes += [node] if namespace?(node)

              next_nodes.push([parent_nodes, node.children])
            end
          end
        end

        nodes = next_nodes
      end

      nil
    end

    def current_pos?(range)
      current_line?(range) && current_character?(range)
    end

    def current_line?(range)
      range.line == location_line_no
    end

    def include_line?(range)
      return false unless range.expression

      if range.is_a?(Parser::Source::Map::Heredoc)
        range.line <= location_line_no && location_line_no <= range.heredoc_end.line
      else
        range.line <= location_line_no && location_line_no <= range.last_line
      end
    end

    def current_character?(range)
      range.column <= character_no && character_no < range.last_column
    end

    def parsed
      @parsed ||= Parser::CurrentRuby.parse(content.read)
    end
  end
end
