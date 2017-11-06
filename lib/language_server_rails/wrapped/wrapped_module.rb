# frozen_string_literal: true

module LanguageServerRails
  class Wrapped
    class WrappedModule < Wrapped
      def self.from_string(string, current_binding = TOPLEVEL_BINDING)
        WrappedModule.new(SafeEvaluator.safe_eval(string, current_binding)) if SafeEvaluator.no_side_effect?(string, current_binding)
      rescue SafeEvaluator::SafeEvaluatorError
        nil
      end

      def initialize(wrapped)
        raise ArgumentError, "a non-module #{wrapped}" unless wrapped.is_a?(::Module)
        super
      end

      def source_location
        return if candidates.empty?

        file, line = candidates.first.source_location
        definition_line, character = module_definition_location(file, line)

        if definition_line && character
          [file] + module_definition_location(file, line)
        else
          # definition not found
          [file, line, 0]
        end
      end

      private

      def module_definition_location(file, max_line)
        lines = File.foreach(file).first(max_line - 1)
        name = wrapped.name.split('::').last.strip
        module_or_class = wrapped.class.to_s.downcase

        regexps = [
          /^\s*#{module_or_class}\s+((\w*)::)*?#{name}/,
          /^\s*(::)?#{name}\.(#{module_or_class}|instance)_eval/
        ]

        regexp = Regexp.union(regexps)

        lines.each_with_index do |line, index|
          next unless regexp.match?(line)
          return [index, line.index(name)]
        end

        nil
      end

      def candidates
        @candidates ||= (wrapped_instance_methods + wrapped_methods).select do |method|
          file, line = method.source_location
          file && line
        end
      end

      def wrapped_instance_methods
        wrapped.instance_methods(false).map do |method_name|
          wrapped.instance_method(method_name)
        end
      end

      def wrapped_methods
        wrapped.methods(false).map do |method_name|
          wrapped.method(method_name)
        end
      end
    end
  end
end
