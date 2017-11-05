# frozen_string_literal: true

require 'thread'

module LanguageServerRails
  module Utils
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
