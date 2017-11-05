# frozen_string_literal: true

module LanguageServerRails
  class Wrapped
    class WrappedModule < Wrapped
      def self.from_string(string, current_binding = TOPLEVEL_BINDING)
        WrappedModule.new(Utils.safe_eval(string, current_binding)) if Utils.no_side_effect_evaluate?(string, current_binding)
      end

      def initialize(wrapped)
        raise ArgumentError, "a non-module #{wrapped}" unless wrapped.is_a?(::Module)
        @wrapped = wrapped
      end
    end
  end
end
