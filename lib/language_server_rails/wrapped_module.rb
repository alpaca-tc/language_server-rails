# frozen_string_literal: true

module LanguageServerRails
  class WrappedModule
    def self.from_string(string, current_binding = TOPLEVEL_BINDING)
      WrappedModule.new(Utils.safe_eval(string, current_binding)) if Utils.no_side_effect_evaluate?(string, current_binding)
    end

    def initialize(wrapped_module)
      raise ArgumentError, "a non-module #{wrapped_module}" unless ::Module === wrapped_module
      @wrapped_module = wrapped_module
    end
  end
end
