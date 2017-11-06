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
        @wrapped = wrapped
      end
    end
  end
end
