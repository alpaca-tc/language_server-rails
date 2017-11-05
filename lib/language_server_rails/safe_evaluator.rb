# frozen_string_literal: true

require 'thread'

module LanguageServerRails
  module SafeEvaluator
    NO_SIDE_EFFECT_EXPRESSION = /variable|constant/

    def self.no_side_effect?(string, current_binding = TOPLEVEL_BINDING)
      expression = current_binding.eval("defined?(#{string})")
      expression == 'self' || NO_SIDE_EFFECT_EXPRESSION.match?(expression)
    rescue SyntaxError
      false
    end

    def self.safe_eval(string, current_binding = TOPLEVEL_BINDING)
      result = nil

      thread = Thread.start do
        $SAFE = 1
        result = current_binding.eval(string)
      end

      thread.join

      result
    end
    # rubocop:enable Security/Eval
  end
end
