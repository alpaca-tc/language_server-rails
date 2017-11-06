# frozen_string_literal: true

require 'timeout'

module LanguageServerRails
  module SafeEvaluator
    class SafeEvaluatorError < StandardError; end

    TIMEOUT = 0.5 # sec
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
        $SAFE = 0 # FIXME: 1にしたいが、requireだけ使いたい
        result = current_binding.eval(string)
        # rubocop:enable Security/Eval
      end

      Timeout.timeout(TIMEOUT) do
        thread.join
      end

      result
    rescue Timeout::Error, SecurityError => error
      raise SafeEvaluatorError, error.message
    rescue => error
      raise SafeEvaluatorError, error.message
    end
  end
end
