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
        definition_line = module_definition_line(file, line)

        [file, definition_line]
      end

      private

      def module_definition_line(file, max_line)
        lines = File.foreach(file).first(max_line - 1)
        name = wrapped.name.split('::').last.strip
        module_or_class = wrapped.class.to_s.downcase

        regexp = Regexp.union([
                                /^\s*#{module_or_class}\s+((\w*)::)*?#{name}/,
                                /^\s*(::)?#{name}\.(#{module_or_class}|instance)_eval/
                              ])

        lines.rindex { |line| regexp.match?(line) }.to_i + 1
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
